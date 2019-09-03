//
//  HealthStoreService.swift
//  FinalChallenge
//
//  Created by Matheus Oliveira Costa on 03/09/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import Foundation
import HealthKit

enum HealthStoreService {
    case stepCount

    var type: HKObjectType? {
        switch self {
        case .stepCount:
            return HKObjectType.quantityType(forIdentifier: .stepCount)
        }
    }

    var queryPredicate: NSPredicate? {
        return nil
    }

}
