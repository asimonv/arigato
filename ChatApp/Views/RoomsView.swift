//
//  RoomsView.swift
//  ChatApp
//
//  Created by Andre Simon on 06-07-20.
//  Copyright © 2020 Andre Simon. All rights reserved.
//

import SwiftUI

struct RoomsView: View {
    @ObservedObject var lm = LocationManager()
    @ObservedObject var roomsViewModel = RoomsViewModel()

    @State var isModal: Bool = false
    @State var roomTitle: String = ""
    
    var modal: some View {
        VStack {
            TextField("title",text: self.$roomTitle).padding(10)
            Button(action: {
                self.isModal = false
                self.roomsViewModel.addRoom(room: Room(title: self.roomTitle, latitude: self.latitude, longitude: self.longitude))
            }) {
                Text("Create")
            }.padding(10)
            Text("Latitude: \(self.latitude)")
            Text("Longitude: \(self.longitude)")
            Text("Placemark: \(self.placemark)")
            Text("Status: \(self.status)")
        }
    }
    
    var latitude: Double  { return lm.location?.latitude ?? 0}
    var longitude: Double { return lm.location?.longitude ?? 0 }
    var placemark: String { return("\(lm.placemark?.description ?? "XXX")") }
    var status: String    { return("\(String(describing: lm.status))") }

    var body: some View {
        List(roomsViewModel.roomCellViewModels) { roomCellVM in
            RoomCell(roomCellVM: roomCellVM)
        }.navigationBarItems(trailing:
         Button(action: {
            self.isModal = true
         }) {
             Text("Add")
         })
        .sheet(isPresented: $isModal, content: {
            self.modal
        })
    }
}

struct RoomsView_Previews: PreviewProvider {
    static var previews: some View {
        RoomsView()
    }
}
