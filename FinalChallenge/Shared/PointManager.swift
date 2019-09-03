//
//  PointManager.swift
//  FinalChallenge
//
//  Created by Martônio Júnior on 02/09/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import Foundation

class PointManager: NSObject {
    static let lastUpdateTime: Date! = Date(timeIntervalSinceReferenceDate: 0)
    static let userPoints = 0
    
    func points(forSteps steps: Double) -> Int {
        return Int(steps)/100
    }
}
