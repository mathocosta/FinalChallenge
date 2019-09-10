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
    let markedValues: [Int]

    var isEmpty: Bool {
        return value.isEmpty
    }

    public init(value: [Int], markedValues: [Int] = []) {
        self.value = value
        self.markedValues = markedValues
        super.init()
    }

    required public init?(coder aDecoder: NSCoder) {
        guard let value = aDecoder.decodeObject(forKey: "value") as? [Int],
            let markedValues = aDecoder.decodeObject(forKey: "mark") as? [Int] else {
            self.value = []
            self.markedValues = []
            return
        }
        self.value = value
        self.markedValues = markedValues
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.value, forKey: "value")
        aCoder.encode(self.markedValues, forKey: "mark")
    }

    public func add(_ item: Int) -> GoalPile {
        var value = self.value
        value.append(item)
        return GoalPile(value: value, markedValues: self.markedValues)
    }

    public func remove(_ item: Int) -> GoalPile {
        var value = self.value
        value.removeAll { (value) -> Bool in
            return item == value
        }
        return GoalPile(value: value, markedValues: self.markedValues)
    }

    public func mark(_ item: Int) -> GoalPile {
        var markedValues = self.markedValues
        markedValues.append(item)
        return GoalPile(value: self.value, markedValues: markedValues)
    }

    public func unmark(_ item: Int) -> GoalPile {
        var markedValues = self.markedValues
        markedValues.removeAll { (value) -> Bool in
            return item == value
        }
        return GoalPile(value: self.value, markedValues: markedValues)
    }

    public func unmarkedGoals() -> [Int] {
        return self.value.filter { (item) -> Bool in
            return !self.markedValues.contains(item)
        }
    }
}
