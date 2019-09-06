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

}
