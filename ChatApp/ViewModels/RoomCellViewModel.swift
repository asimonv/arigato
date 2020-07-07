//
//  RoomCellViewModel.swift
//  ChatApp
//
//  Created by Andre Simon on 07-07-20.
//  Copyright © 2020 Andre Simon. All rights reserved.
//

import Foundation
import Combine
import Resolver

class RoomCellViewModel: ObservableObject, Identifiable  {
  @Injected var roomsRepository: RoomsRepository
  
  @Published var room: Room
  
  var id: String = ""
  private var cancellables = Set<AnyCancellable>()
  
    static func newRoom(title: String, latitude: Double, longitude: Double) -> RoomCellViewModel {
        RoomCellViewModel(room: Room(title: title, latitude: latitude, longitude: longitude))
  }
  
  init(room: Room) {
    self.room = room
    
    $room
      .compactMap { $0.id }
      .assign(to: \.id, on: self)
      .store(in: &cancellables)
  }
  
}
