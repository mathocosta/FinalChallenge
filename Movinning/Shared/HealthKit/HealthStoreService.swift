//
//  HealthStoreService.swift
//  FinalChallenge
//
//  Created by Matheus Oliveira Costa on 03/09/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import Foundation
import HealthKit

enum HealthStoreService: String, CaseIterable {
    case stepCount
    case distanceWalkingRunning
    case soccer
    case cycling
    case functionalTraining
    case traditionalTraining
    case cricket
    case hockey
    case tennis
    case volleyball
    case tableTennis
    case basketball
    case baseball
    case rugby
    case golf
    case swimming

    var type: HKObjectType? {
        switch self {
        case .stepCount:
            do {
                let usingWheelchair = try HealthStoreManager.healthStore.wheelchairUse().wheelchairUse
                if usingWheelchair == .yes {
                    return HKObjectType.quantityType(forIdentifier: .pushCount)
                } else {
                    return HKObjectType.quantityType(forIdentifier: .stepCount)
                }
            } catch {
                return HKObjectType.quantityType(forIdentifier: .stepCount)
            }
        case .distanceWalkingRunning:
            do {
                let usingWheelchair = try HealthStoreManager.healthStore.wheelchairUse().wheelchairUse
                if usingWheelchair == .yes {
                    return HKObjectType.quantityType(forIdentifier: .distanceWheelchair)
                } else {
                    return HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)
                }
            } catch {
                return HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)
            }
        case .cycling:
            return HKObjectType.quantityType(forIdentifier: .distanceCycling)
        case .swimming:
            return HKObjectType.quantityType(forIdentifier: .swimmingStrokeCount)
        default:
            return HKObjectType.quantityType(forIdentifier: .appleExerciseTime)
        }
    }

    var queryPredicate: NSPredicate? {
        switch self {
        case .soccer:
            return HKQuery.predicateForWorkouts(with: .soccer)
        case .functionalTraining:
            return HKQuery.predicateForWorkouts(with: .functionalStrengthTraining)
        case .traditionalTraining:
            return HKQuery.predicateForWorkouts(with: .traditionalStrengthTraining)
        case .cricket:
            return HKQuery.predicateForWorkouts(with: .cricket)
        case .hockey:
            return HKQuery.predicateForWorkouts(with: .hockey)
        case .tennis:
            return HKQuery.predicateForWorkouts(with: .tennis)
        case .volleyball:
            return HKQuery.predicateForWorkouts(with: .volleyball)
        case .tableTennis:
            return HKQuery.predicateForWorkouts(with: .tableTennis)
        case .basketball:
            return HKQuery.predicateForWorkouts(with: .basketball)
        case .baseball:
            return HKQuery.predicateForWorkouts(with: .baseball)
        case .rugby:
            return HKQuery.predicateForWorkouts(with: .rugby)
        case .golf:
            return HKQuery.predicateForWorkouts(with: .golf)
        default:
            return nil
        }
    }

    static var allTypes: Set<HKObjectType> {
        let identifiers: [HKQuantityTypeIdentifier] =
        [
            .appleExerciseTime,
            .pushCount,
            .stepCount,
            .distanceWheelchair,
            .distanceWalkingRunning,
            .distanceCycling,
            .swimmingStrokeCount
        ]

        var types: [HKObjectType] = []
        for id in identifiers {
            if let object = HKObjectType.quantityType(forIdentifier: id) {
                types.append(object)
            }
        }
        return Set(types)
    }

    static var allAllowedSports: Set<Sport> = {
        let sports = UserDefaults.standard.userPreferences

        if sports.count == 0 {
            return Sport.allTypes
        }

        return Set(sports)
    }()

    static var exerciseIntensity: ExerciseIntensity = {
        return UserDefaults.standard.practiceTime
    }()

    var unit: HKUnit {
        switch self {
        case .stepCount,
             .swimming:
            return HKUnit.count()
        case .distanceWalkingRunning,
             .cycling:
            return HKUnit.meter()
        case .soccer,
             .functionalTraining,
             .traditionalTraining,
             .hockey,
             .tennis,
             .tableTennis,
             .basketball,
             .rugby,
             .golf,
             .cricket,
             .volleyball,
             .baseball:
            return HKUnit.minute()
        }
    }

    var balanceValue: Double {
        switch self {
        case .stepCount:
            return 50.0
        case .distanceWalkingRunning:
            return 20.0
        case .soccer:
            return 0.063
        case .cycling:
            return 26
        case .functionalTraining, .traditionalTraining:
            return 0.09
        case .cricket:
            return 0.31
        case .hockey:
            return 0.26
        case .tennis:
            return 0.1
        case .volleyball:
            return 0.16
        case .tableTennis:
            return 0.26
        case .basketball:
            return 0.2
        case .baseball:
            return 0.34
        case .rugby:
            return 0.13
        case .golf:
            return 0.078
        case .swimming:
            return 2.71
        }
    }

}

extension HealthStoreService {
    static func type(forTag tag: String) -> HealthStoreService {
        return HealthStoreService(rawValue: tag) ?? .stepCount
    }
}
