//
//  MessageCell.swift
//  ChatApp
//
//  Created by Andre Simon on 06-07-20.
//  Copyright © 2020 Andre Simon. All rights reserved.
//

import SwiftUI

struct MessageCell: View {
    @ObservedObject var messageCellVM: MessageCellViewModel
    var body: some View {
         
        HStack {
            HStack {
                Text(messageCellVM.message.text).padding(10).background(Color.blue)
                .cornerRadius(28)
                    .foregroundColor(.white)
                
            }
        }
    }
}
