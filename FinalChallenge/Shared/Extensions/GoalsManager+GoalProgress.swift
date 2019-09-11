//
//  GoalsManager+GoalProgress.swift
//  FinalChallenge
//
//  Created by Martônio Júnior on 10/09/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import Foundation
import HealthKit

extension GoalsManager {
    static func checkForCompletedGoals(for user: User) {
        let goals = GoalsManager.currentTimedGoals(of: user)
        for goal in goals {
            progress(for: user, on: goal) { (progress, required) in
                if progress > required {
                    GoalsManager.markCompleted(goal: goal, from: user)
                }
            }
        }
        CoreDataManager.saveContext()
    }

    static func progress(for user: User, on goal: Goal, completion: @escaping ((Double, Double) -> Void)) {
        let manager = HealthStoreManager()
        let process: (Result<HKStatistics, Error>) -> Void = { (results) -> Void in
            let service = HealthStoreService.type(forTag: goal.activityType)
            let progressAmount = GoalsManager.progressAmount(results, for: service)
            let goalAmount = goal.requiredAmount()
            completion(progressAmount, Double(goalAmount))
        }

        let serviceType = HealthStoreService.type(forTag: goal.activityType)
        if goal.dailyReset {
            manager.quantitySumToday(of: serviceType) { (results) in
                process(results)
            }
        } else {
            manager.quantitySumSinceLastSunday(of: serviceType) { (results) in
                process(results)
            }
        }
    }

    static func progressAmount(_ results: Result<HKStatistics, Error>, for service: HealthStoreService) -> Double {
        switch results {
        case .success(let statistics):
            if let quantity = statistics.sumQuantity() {
                return quantity.doubleValue(for: service.unit())
            }
        case .failure(let error):
            print(error.localizedDescription)
        }
        return 0
    }
}
