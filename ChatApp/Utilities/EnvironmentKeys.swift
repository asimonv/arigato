//
//  EnvironmentKeys.swift
//  ChatApp
//
//  Created by Andre Simon on 06-07-20.
//  Copyright © 2020 Andre Simon. All rights reserved.
//

import Foundation
import SwiftUI

struct WindowKey: EnvironmentKey {
  struct Value {
    weak var value: UIWindow?
  }
  
  static let defaultValue: Value = .init(value: nil)
}

extension EnvironmentValues {
  var window: UIWindow? {
    get { return self[WindowKey.self].value }
    set { self[WindowKey.self] = .init(value: newValue) }
  }
}
