//
//  MessageRepository.swift
//  ChatApp
//
//  Created by Andre Simon on 06-07-20.
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

class BaseMessagesRepository {
    @Published var messages = [Message]()
}

protocol MessagesRepository: BaseMessagesRepository {
    func loadData(_ roomId: String)
    func addMessage(_ message: Message)
    func removeMessage(_ message: Message)
    func updateMessage(_ message: Message)
}

class FirestoreMessagesRepository: BaseMessagesRepository, MessagesRepository, ObservableObject {
    @Injected var db: Firestore
    @Injected var authenticationService: AuthenticationService
    @LazyInjected var functions: Functions

    var messagesPath: String = "messages"
    var userId: String = "unknown"
    
  
    private var listenerRegistration: ListenerRegistration?
    private var cancellables = Set<AnyCancellable>()

    func loadData(_ roomId: String) {
        if listenerRegistration != nil {
          listenerRegistration?.remove()
        }
        listenerRegistration = db.collection(messagesPath)
          .whereField("roomId", isEqualTo: roomId)
          .order(by: "createdTime")
          .addSnapshotListener { (querySnapshot, error) in
            if let querySnapshot = querySnapshot {
              self.messages = querySnapshot.documents.compactMap { document -> Message? in
                try? document.data(as: Message.self)
              }
            }
          }
    }
  
  func addMessage(_ message: Message) {
    do {
      var userMessage = message
      userMessage.userId = self.userId
      let _ = try db.collection(messagesPath).addDocument(from: userMessage)
    }
    catch {
      fatalError("Unable to encode message: \(error.localizedDescription).")
    }
  }
  
  func removeMessage(_ message: Message) {
    if let messageID = message.id {
      db.collection(messagesPath).document(messageID).delete { (error) in
        if let error = error {
          print("Unable to remove document: \(error.localizedDescription)")
        }
      }
    }
  }
  
  func updateMessage(_ message: Message) {
    if let messageID = message.id {
      do {
        try db.collection(messagesPath).document(messageID).setData(from: message)
      }
      catch {
        fatalError("Unable to encode message: \(error.localizedDescription).")
      }
    }
  }
  
  func migrateMessages(fromUserId: String) {
    let data = ["previousUserId": fromUserId]
    functions.httpsCallable("migrateMessages").call(data) { (result, error) in
      if let error = error as NSError? {
        print("Error: \(error.localizedDescription)")
      }
      print("Function result: \(result?.data ?? "(empty)")")
    }
  }
}
