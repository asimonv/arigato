//
//  MessagesListView.swift
//  ChatApp
//
//  Created by Andre Simon on 06-07-20.
//  Copyright © 2020 Andre Simon. All rights reserved.
//

import SwiftUI

struct MessagesListView: View {
    @ObservedObject var messageListViewModel: MessagesListViewModel
    
    var name = ""
    var roomId: String
    
    init(roomId: String) {
        self.roomId = roomId
        messageListViewModel = MessagesListViewModel(roomId: roomId)
    }
    
    @State var write = ""
    var body: some View {
        VStack {
            List(messageListViewModel.messageCellViewModels) { messageCellVM in
                MessageCell(messageCellVM: messageCellVM)
                
            }.navigationBarTitle("Chats", displayMode: .inline)
            
            HStack {
                TextField("message...",text: self.$write).padding(10)
                    .background(Color(red: 233.0/255, green: 234.0/255, blue: 243.0/255))
                .cornerRadius(25)
                
                Button(action: {
                    if self.write.count > 0 {
                        self.messageListViewModel.addMessage(message: Message(text: self.write, roomId: self.roomId))
                        self.write = ""
                    } else {
                        
                    }
                }) {
                    Image(systemName: "paperplane.fill").font(.system(size: 20))
                        .foregroundColor((self.write.count > 0) ? Color.blue : Color.gray)
                        .rotationEffect(.degrees(50))
                    
                }
            }.padding()
        }.onAppear {
            self.messageListViewModel.loadMessages(roomId: self.roomId)
        }.onDisappear {
            // repo will unsubscribe when called again
            self.messageListViewModel.loadMessages(roomId: self.roomId)
        }
    }
}
