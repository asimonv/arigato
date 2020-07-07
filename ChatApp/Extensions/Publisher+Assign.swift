//
//  Publisher+Assign.swift
//  ChatApp
//
//  Created by Andre Simon on 06-07-20.
//  Copyright © 2020 Andre Simon. All rights reserved.
//

import Combine

/// https://forums.swift.org/t/does-assign-to-produce-memory-leaks/29546/11
extension Publisher where Failure == Never {
  func assign<Root: AnyObject>(to keyPath: ReferenceWritableKeyPath<Root, Output>, on root: Root) -> AnyCancellable {
    sink { [weak root] in
      root?[keyPath: keyPath] = $0
    }
  }
}
