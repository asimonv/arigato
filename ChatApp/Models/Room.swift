//
//  Room.swift
//  ChatApp
//
//  Created by Andre Simon on 07-07-20.
//  Copyright © 2020 Andre Simon. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Room: Codable, Identifiable {
    @DocumentID var id: String?
    var title: String
    @ServerTimestamp var createdTime: Timestamp?
    var userId: String?
    var latitude: Double
    var longitude: Double
}
