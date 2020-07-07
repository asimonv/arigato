//
//  Message.swift
//  ChatApp
//
//  Created by Andre Simon on 06-07-20.
//  Copyright © 2020 Andre Simon. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Message: Codable, Identifiable {
  @DocumentID var id: String?
  var text: String
  @ServerTimestamp var createdTime: Timestamp?
  var userId: String?
}
