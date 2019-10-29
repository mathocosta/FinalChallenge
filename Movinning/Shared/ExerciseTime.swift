//
//  ExerciseTime.swift
//  Movinning
//
//  Created by Martônio Júnior on 24/10/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import Foundation
import HealthKit

enum ExerciseIntensity: Int {
    case halfHour = 30
    case oneHour = 60
    case oneAndAHalfHour = 90
    case twoHours = 120
    case twoAndAHalfHours = 150

    func recommendedAmount(for service: HealthStoreService) -> Int {
        switch service.unit {
        case HKUnit.count():
            if service == .stepCount {
                return self.rawValue * 110 // Average steps / minute
            } else if service == .swimming {
                return self.rawValue * 50 // Average swimming strokes / minute
            }
        case HKUnit.meter():
            if service == .distanceWalkingRunning {
                return self.rawValue * 100 // Average meters / minute
            } else if service == .cycling {
                return self.rawValue * 400 // Average meters / minute
            }
        case HKUnit.minute():
            return self.rawValue
        default:
            break
        }
        return 0
    }

    func recommend(_ goal: Goal) -> Bool {
        let service = HealthStoreService.type(forTag: goal.activityType)
        let recommendedAmount = HealthStoreService.exerciseIntensity.recommendedAmount(for: service)
            * (goal.dailyReset ? 1 : 7)
        return goal.requiredAmount() <= recommendedAmount
    }
}
