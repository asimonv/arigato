//
//  SignInView.swift
//  ChatApp
//
//  Created by Andre Simon on 06-07-20.
//  Copyright © 2020 Andre Simon. All rights reserved.
//

import SwiftUI

struct SignInView: View {
  @Environment(\.window) var window: UIWindow?
  @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
  var body: some View {
    VStack {
      Image("Logo")
        .resizable()
        .aspectRatio(contentMode: .fit)
        .padding(.horizontal, 100)
        .padding(.top, 100)
        .padding(.bottom, 50)
      
      
      HStack {
        Text("Welcome to")
          .font(.title)
        
        Text("Make It So")
          .font(.title)
          .fontWeight(.semibold)
      }
      
      Text("Create an account to save your tasks and access them anywhere. It's free. \n Forever.")
        .font(.headline)
        .fontWeight(.medium)
        .multilineTextAlignment(.center)
        .padding(.top, 20)
      
      Spacer()

      
      // other buttons will go here
      
      Divider()
        .padding(.horizontal, 15.0)
        .padding(.top, 20.0)
        .padding(.bottom, 15.0)

      
      Text("By using Make It So you agree to our Terms of Use and Service Policy")
        .multilineTextAlignment(.center)
    }
  }
}

struct SignInView_Previews: PreviewProvider {
  static var previews: some View {
    SignInView()
  }
}
