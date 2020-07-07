//
//  ListMessage.swift
//  Chats
//
//  Created by App-Designer2 . on 26.01.20.
//  Copyright © 2020 App-Designer2 . All rights reserved.
//

import SwiftUI


struct ListMessage : View {
    
    var msg = ""
    
    var Message = false
    var user = ""
    
    var body: some View {
         
        HStack {
            if Message {
                Spacer()
                
                HStack {
                Text(msg).padding(10).background(Color.secondary)
                .cornerRadius(18)
                    .foregroundColor(.white)
                    
                }
            } else {
                HStack {
                    Text(msg).padding(10).background(Color.blue)
                    .cornerRadius(28)
                        .foregroundColor(.white)
                    
                }
                Spacer()
            }
        }
    }
}
