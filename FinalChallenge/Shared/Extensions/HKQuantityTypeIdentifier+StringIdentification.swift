//
//  HKQuantityTypeIdentifier+StringIdentification.swift
//  FinalChallenge
//
//  Created by Martônio Júnior on 06/09/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import Foundation
import HealthKit

extension HKQuantityTypeIdentifier {
    func balanceValue() -> Double {
        switch self {
        case .stepCount:
            return 50.0
        case .distanceWalkingRunning:
            return 20.0
        default:
            return 1.0
        }
    }
    
    static func type(forTag tag: String) -> HKQuantityTypeIdentifier {
        switch tag {
        case "stepCount":
            return .stepCount
        case "distanceWalkingRunning":
            return .distanceWalkingRunning
        default:
            return .stepCount
        }
    }
}
