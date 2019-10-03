//
//  Array+ToSet.swift
//  Splay
//
//  Created by Martônio Júnior on 26/09/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import Foundation

extension Array where Element == AnyHashable {
    func toSet() -> Set<Element> {
        return Set(arrayLiteral: self)
    }
}
