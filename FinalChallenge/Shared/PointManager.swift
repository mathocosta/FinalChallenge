//
//  PointManager.swift
//  FinalChallenge
//
//  Created by Martônio Júnior on 02/09/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import Foundation

class PointManager: NSObject {
    static let stepsForPoint: Int = 100
    
    static func points(forSteps steps: Double) -> Int {
        return Int(steps)/stepsForPoint
    }
}
