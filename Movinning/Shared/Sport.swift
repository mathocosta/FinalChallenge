//
//  Sports.swift
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
    
    func service(for sport: Sport) -> Set<HealthStoreService> {
        switch sport {
            case .walking:
                return Set([HealthStoreService.stepCount])
            case .running:
                return Set([HealthStoreService.distanceWalkingRunning])
            case .soccer:
                return Set([HealthStoreService.soccer])
            case .cycling:
                return Set([HealthStoreService.cycling])
            case .training:
                return Set([HealthStoreService.functionalTraining, HealthStoreService.traditionalTraining])
            case .cricket:
                return Set([HealthStoreService.cricket])
            case .hockey:
                return Set([HealthStoreService.hockey])
            case .tennis:
                return Set([HealthStoreService.tennis])
            case .volleyball:
                return Set([HealthStoreService.volleyball])
            case .tableTennis:
                return Set([HealthStoreService.tableTennis])
            case .basketball:
                return Set([HealthStoreService.basketball])
            case .baseball:
                return Set([HealthStoreService.baseball])
            case .rugby:
                return Set([HealthStoreService.rugby])
            case .golf:
                return Set([HealthStoreService.golf])
            case .swimming:
                return Set([HealthStoreService.swimming])
        }
    }
    
    static var allTypes: Set<Sport> {
        let all = Sport.allCases
        return Set(all)
    }
    
    func name() -> String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
    
    func permissions(for: [Sport]) -> [HKObjectType] {
        return []
    }
}
