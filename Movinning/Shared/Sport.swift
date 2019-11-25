//
//  Sport.swift
//  Movinning
//
//  Created by Martônio Júnior on 23/10/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import Foundation
import HealthKit

enum Sport: String, CaseIterable {
    case walking
    case running
    case soccer
    case cycling
    case training
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

    var localizedName: String {
        return NSLocalizedString(rawValue, comment: "")
    }

    func services() -> [HealthStoreService] {
        switch self {
        case .walking:
            return [HealthStoreService.stepCount]
        case .running:
            return [HealthStoreService.distanceWalkingRunning]
        case .soccer:
            return [HealthStoreService.soccer]
        case .cycling:
            return [HealthStoreService.cycling]
        case .training:
            return [HealthStoreService.functionalTraining, HealthStoreService.traditionalTraining]
        case .cricket:
            return [HealthStoreService.cricket]
        case .hockey:
            return [HealthStoreService.hockey]
        case .tennis:
            return [HealthStoreService.tennis]
        case .volleyball:
            return [HealthStoreService.volleyball]
        case .tableTennis:
            return [HealthStoreService.tableTennis]
        case .basketball:
            return [HealthStoreService.basketball]
        case .baseball:
            return [HealthStoreService.baseball]
        case .rugby:
            return [HealthStoreService.rugby]
        case .golf:
            return [HealthStoreService.golf]
        case .swimming:
            return [HealthStoreService.swimming]
        }
    }

    static var allTypes: Set<Sport> {
        let all = Sport.allCases
        return Set(all)
    }

    static func permissions(for sports: Set<Sport>) -> Set<HKObjectType> {
        var permissions: [HKObjectType] = []
        for sport in sports {
            let services = sport.services()
            for service in services {
                if let type = service.type, !permissions.contains(type) {
                    permissions.append(type)
                }
            }
        }
        return Set(permissions)
    }

    func achievementValue() -> Int {
        for service in services() {
            switch service.unit {
            case HKUnit.count():
                if service == .stepCount {
                    return 10000
                } else if service == .swimming {
                    return 1000
                }
            case HKUnit.meter():
                return 2000
            case HKUnit.minute():
                return 120
            default:
                break
            }
        }
        return 0
    }
}
