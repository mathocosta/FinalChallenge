//
//  ArrayPile.swift
//  Movinning
//
//  Created by Martônio Júnior on 26/11/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit

public class ArrayPile: NSObject, NSCoding, Encodable, Decodable {
    var value: [Int]

    public init(value: [Int]) {
        self.value = value
        super.init()
    }

    required public init?(coder aDecoder: NSCoder) {
        guard let value = aDecoder.decodeObject(forKey: "value") as? [Int] else {
            self.value = []
            return
        }
        self.value = value
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.value, forKey: "value")
    }

    public func add(_ item: Int) -> ArrayPile {
        var value = self.value
        value.append(item)
        return ArrayPile(value: value)
    }

    public func remove(_ item: Int) -> ArrayPile {
        var value = self.value
        value.removeAll { return $0 == item }
        return ArrayPile(value: value)
    }
}
