//
//  RoomsListViewModel.swift
//  ChatApp
//
//  Created by Andre Simon on 07-07-20.
//  Copyright © 2020 Andre Simon. All rights reserved.
//

import Foundation
import Combine
import Resolver

class RoomsViewModel: ObservableObject {
  @Published var roomsRepository: RoomsRepository = Resolver.resolve()
  @Published var roomCellViewModels = [RoomCellViewModel]()
  private var cancellables = Set<AnyCancellable>()
  
  init() {
    roomsRepository.$rooms.map { rooms in
      rooms.map { room in
        RoomCellViewModel(room: room)
      }
    }
    .assign(to: \.roomCellViewModels, on: self)
    .store(in: &cancellables)
  }
  
  func removeRoom(atOffsets indexSet: IndexSet) {
    // remove from repo
    let viewModels = indexSet.lazy.map { self.roomCellViewModels[$0] }
    viewModels.forEach { roomCellViewModel in
      roomsRepository.removeRoom(roomCellViewModel.room)
    }
  }
  
  func addRoom(room: Room) {
    roomsRepository.addRoom(room)
  }
}
