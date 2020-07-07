//
//  CLLocation+Coordinates.swift
//  ChatApp
//
//  Created by Andre Simon on 06-07-20.
//  Copyright © 2020 Andre Simon. All rights reserved.
//

import Foundation
import CoreLocation

extension CLLocation {
    var latitude: Double {
        return self.coordinate.latitude
    }
    
    var longitude: Double {
        return self.coordinate.longitude
    }
}
