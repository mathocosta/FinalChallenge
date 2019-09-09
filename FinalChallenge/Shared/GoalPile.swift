//
//  GoalPile.swift
//  FinalChallenge
//
//  Created by Martônio Júnior on 09/09/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import Foundation

public class GoalPile: NSObject, NSCoding {
    let value: [Int]

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
}
