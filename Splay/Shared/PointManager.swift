//
//  PointManager.swift
//  FinalChallenge
//
//  Created by Martônio Júnior on 02/09/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import Foundation

class PointManager: NSObject {
//    static var display: PointDisplayUpdater?

    static func add(_ points: Int, to user: User) {
        user.points += Int32(points)
//        display?.didUpdate(newAmount: Int(user.points))
    }
}
