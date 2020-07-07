//
//  MessageCellViewModel.swift
//  ChatApp
//
//  Created by Andre Simon on 06-07-20.
//  Copyright © 2020 Andre Simon. All rights reserved.
//

import Foundation
import Combine
import Resolver

class MessageCellViewModel: ObservableObject, Identifiable  {
  @Injected var messagesRepository: MessagesRepository
  
  @Published var message: Message
  
  var id: String = ""
  private var cancellables = Set<AnyCancellable>()
  
  static func newMessage() -> MessageCellViewModel {
    MessageCellViewModel(message: Message(text: ""))
  }
  
  init(message: Message) {
    self.message = message
    
    $message
      .compactMap { $0.id }
      .assign(to: \.id, on: self)
      .store(in: &cancellables)
  }
  
}
