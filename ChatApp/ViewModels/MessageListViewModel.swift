//
//  MessageListViewModel.swift
//  ChatApp
//
//  Created by Andre Simon on 06-07-20.
//  Copyright © 2020 Andre Simon. All rights reserved.
//

import Foundation
import Combine
import Resolver

class MessagesListViewModel: ObservableObject {
  @Published var messageRepository: MessagesRepository = Resolver.resolve()
  @Published var messageCellViewModels = [MessageCellViewModel]()
  private var cancellables = Set<AnyCancellable>()
  
  init() {
    messageRepository.$messages.map { messages in
      messages.map { message in
        MessageCellViewModel(message: message)
      }
    }
    .assign(to: \.messageCellViewModels, on: self)
    .store(in: &cancellables)
  }
  
  func removeMessages(atOffsets indexSet: IndexSet) {
    // remove from repo
    let viewModels = indexSet.lazy.map { self.messageCellViewModels[$0] }
    viewModels.forEach { messageCellViewModel in
      messageRepository.removeMessage(messageCellViewModel.message)
    }
  }
  
  func addMessage(message: Message) {
    messageRepository.addMessage(message)
  }
}
