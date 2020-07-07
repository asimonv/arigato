//
//  RoomRepository.swift
//  ChatApp
//
//  Created by Andre Simon on 07-07-20.
//  Copyright © 2020 Andre Simon. All rights reserved.
//

import Foundation
import Disk

import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseFunctions

import Combine
import Resolver

class BaseRoomsRepository {
  @Published var rooms = [Room]()
}

protocol RoomsRepository: BaseRoomsRepository {
  func addRoom(_ room: Room)
  func removeRoom(_ room: Room)
  func updateRoom(_ room: Room)
}


class LocalRoomsRepository: BaseRoomsRepository, RoomsRepository, ObservableObject {
  override init() {
    super.init()
    loadData()
  }
  
  func addRoom(_ room: Room) {
    self.rooms.append(room)
    saveData()
  }
  
  func removeRoom(_ room: Room) {
    if let index = rooms.firstIndex(where: { $0.id == room.id }) {
        self.rooms.remove(at: index)
      saveData()
    }
  }
  
  func updateRoom(_ room: Room) {
    if let index = self.rooms.firstIndex(where: { $0.id == room.id } ) {
      self.rooms[index] = room
      saveData()
    }
  }
  
  private func loadData() {
    if let retrievedRooms = try? Disk.retrieve("rooms.json", from: .documents, as: [Room].self) {
      self.rooms = retrievedRooms
    }
  }
  
  private func saveData() {
    do {
      try Disk.save(self.rooms, to: .documents, as: "rooms.json")
    }
    catch let error as NSError {
      fatalError("""
        Domain: \(error.domain)
        Code: \(error.code)
        Description: \(error.localizedDescription)
        Failure Reason: \(error.localizedFailureReason ?? "")
        Suggestions: \(error.localizedRecoverySuggestion ?? "")
        """)
    }
  }
}

class FirestoreRoomsRepository: BaseRoomsRepository, RoomsRepository, ObservableObject {
    @Injected var db: Firestore
    @Injected var authenticationService: AuthenticationService
    @LazyInjected var functions: Functions

    var messagesPath: String = "messages"
    var roomsPath: String = "rooms"
    var userId: String = "unknown"
  
    private var listenerRegistration: ListenerRegistration?
    private var cancellables = Set<AnyCancellable>()
  
    override init() {
        super.init()

        authenticationService.$user
          .compactMap { user in
            user?.uid
          }
          .assign(to: \.userId, on: self)
          .store(in: &cancellables)

        // (re)load data if user changes
        authenticationService.$user
          .receive(on: DispatchQueue.main)
          .sink { [weak self] user in
            self?.loadData()
          }
          .store(in: &cancellables)
    }
  
  private func loadData() {
    if listenerRegistration != nil {
      listenerRegistration?.remove()
    }
    listenerRegistration = db.collection(roomsPath)
      .whereField("userId", isEqualTo: self.userId)
      .order(by: "createdTime")
      .addSnapshotListener { (querySnapshot, error) in
        if let querySnapshot = querySnapshot {
          self.rooms = querySnapshot.documents.compactMap { document -> Room? in
            try? document.data(as: Room.self)
          }
        }
      }
  }
  
  func addRoom(_ room: Room) {
    do {
      var userRoom = room
      userRoom.userId = self.userId
      let _ = try db.collection(roomsPath).addDocument(from: userRoom)
    }
    catch {
      fatalError("Unable to encode message: \(error.localizedDescription).")
    }
  }
  
  func removeRoom(_ room: Room) {
    if let messageID = room.id {
      db.collection(roomsPath).document(messageID).delete { (error) in
        if let error = error {
          print("Unable to remove document: \(error.localizedDescription)")
        }
      }
    }
  }
  
  func updateRoom(_ room: Room) {
    if let messageID = room.id {
      do {
        try db.collection(roomsPath).document(messageID).setData(from: room)
      }
      catch {
        fatalError("Unable to encode message: \(error.localizedDescription).")
      }
    }
  }
  
  func migrateRooms(fromUserId: String) {
    let data = ["previousUserId": fromUserId]
    functions.httpsCallable("migrateRooms").call(data) { (result, error) in
      if let error = error as NSError? {
        print("Error: \(error.localizedDescription)")
      }
      print("Function result: \(result?.data ?? "(empty)")")
    }
  }
}


