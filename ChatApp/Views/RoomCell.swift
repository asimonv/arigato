//
//  RoomCell.swift
//  ChatApp
//
//  Created by Andre Simon on 07-07-20.
//  Copyright © 2020 Andre Simon. All rights reserved.
//

import SwiftUI

struct RoomCell: View {
    @ObservedObject var roomCellVM: RoomCellViewModel
    var body: some View {
        NavigationLink(destination: MessagesListView()) {
            HStack {
                Text(roomCellVM.room.title).padding(10)
            }
        }

    }
}
