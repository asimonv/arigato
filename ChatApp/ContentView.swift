//
//  ContentView.swift
//  ChatApp
//
//  Created by Andre Simon on 06-07-20.
//  Copyright © 2020 Andre Simon. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var selection = 0
 
    var body: some View {
        TabView(selection: $selection){
            NavigationView {
                RoomsView()
                .navigationBarTitle("Rooms", displayMode: .inline)
            }
            .tabItem {
                VStack {
                    Image("first")
                    Text("First")
                }
            }
            .tag(0)
            NavigationView {
                MessagesListView()
            }
            .tabItem {
                VStack {
                    Image("second")
                    Text("Second")
                }
            }
            .tag(1)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
