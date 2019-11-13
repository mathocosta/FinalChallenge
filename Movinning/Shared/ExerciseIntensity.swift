//
//  ExerciseIntensity.swift
//  Movinning
//
//  Created by Martônio Júnior on 24/10/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import Foundation
import HealthKit

enum ExerciseIntensity: Int, CaseIterable {
    case halfHour = 30
    case oneHour = 60
    case oneAndAHalfHour = 90
    case twoHours = 120
    case twoAndAHalfHours = 150

    func amount() -> Int {
        return self.rawValue
    }

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

    static var allTypes: Set<ExerciseIntensity> {
        let all = ExerciseIntensity.allCases
        return Set(all)
    }

    func title() -> String {
        return String(describing: self.rawValue)+"min"
    }

    func index() -> Int {
        switch self {
        case .halfHour:
            return 0
        case .oneHour:
            return 1
        case .oneAndAHalfHour:
            return 2
        case .twoHours:
            return 3
        case .twoAndAHalfHours:
            return 4
        }
    }

    static func intensity(for index: Int) -> ExerciseIntensity {
        switch index {
        case 0:
            return .halfHour
        case 1:
            return .oneHour
        case 2:
            return .oneAndAHalfHour
        case 3:
            return .twoHours
        case 4:
            return .twoAndAHalfHours
        default:
            return .twoAndAHalfHours
        }
    }

    func recommend(_ goal: Goal) -> Bool {
        let service = HealthStoreService.type(forTag: goal.activityType)
        let recommendedAmount = self.recommendedAmount(for: service)
            * (goal.dailyReset ? 1 : 7)
        return goal.requiredAmount() <= recommendedAmount
    }
}
