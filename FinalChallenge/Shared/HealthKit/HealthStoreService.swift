//
//  HealthStoreService.swift
//  FinalChallenge
//
//  Created by Matheus Oliveira Costa on 03/09/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import Foundation
import HealthKit

enum HealthStoreService: CaseIterable {
    case stepCount
    case distanceWalkingRunning

    var type: HKObjectType? {
        switch self {
        case .stepCount:
            return HKObjectType.quantityType(forIdentifier: .stepCount)
        case .distanceWalkingRunning:
            return HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)
        }
    }

    var queryPredicate: NSPredicate? {
        return nil
    }

    static var allTypes: Set<HKObjectType> {
        let types = HealthStoreService.allCases.compactMap { $0.type }

        return Set(types)
    }

    var unit: HKUnit {
        switch self {
        case .stepCount:
            return HKUnit.count()
        case .distanceWalkingRunning:
            return HKUnit(from: .meter)
        }
    }

    var balanceValue: Double {
        switch self {
        case .stepCount:
            return 50.0
        case .distanceWalkingRunning:
            return 20.0
        }
    }

}

extension HealthStoreService {
    static func type(forTag tag: String) -> HealthStoreService {
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
