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
        CoreDataStore.saveContext()
    }

    static func progress(for user: User, on goal: Goal, completion: @escaping ((Double, Double) -> Void)) {
        let manager = HealthStoreManager()
        let process: (Result<HKStatistics, Error>) -> Void = { (results) -> Void in
            let service = HealthStoreService.type(forTag: goal.activityType)
            let progressAmount = GoalsManager.progressAmount(results, for: service)
            let goalAmount = goal.requiredAmount()
            completion(progressAmount, Double(goalAmount))
        }

        let processEachDay: ([HKStatistics]) -> Void = { (results) -> Void in
            var progressAmount: Double = 0.0
            let goalAmount = goal.requiredAmount()
            for item in results {
                let service = HealthStoreService.type(forTag: goal.activityType)
                progressAmount = GoalsManager.progressAmount(item, for: service)
                if Int(progressAmount) > goalAmount {
                    break
                }
            }
            completion(progressAmount, Double(goalAmount))
        }

        let serviceType = HealthStoreService.type(forTag: goal.activityType)
        if goal.dailyReset {
            manager.quantitySumThisWeekPerDay(of: serviceType) { (results) in
                processEachDay(results)
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
                return quantity.doubleValue(for: service.unit)
            }
        case .failure(let error):
            print(error.localizedDescription)
        }
        return 0
    }

    static func progressAmount(_ statistics: HKStatistics, for service: HealthStoreService) -> Double {
        if let quantity = statistics.sumQuantity() {
            return quantity.doubleValue(for: service.unit)
        }
        return 0
    }

    static func teamGoals(for user: User) -> [Goal] {
        guard let team = user.team,
            let goalIDs = team.goals?.value,
            let amountOfMembers = team.members?.count else { return [] }
        return getGoals(withIDs: Array(goalIDs), amountOfUsers: amountOfMembers)
    }

    static func updateGroupGoalsProgress(for user: User) {
        SessionManager.current.updateLocallyTeam(of: user).done  { _ in
            guard let team = user.team, var values = team.teamProgress?.value else { return }
            let goals = GoalsManager.teamGoals(for: user)
            let group = DispatchGroup()
            for index in 0..<goals.count {
                let goal = goals[index]
                guard HealthStoreService.allAllowedSports.contains(where: {
                    return $0.services().contains(where: {
                        return $0 == HealthStoreService.type(forTag: goal.activityType)
                    })
                }) else {
                    continue
                }
                group.enter()
                progress(for: team, on: goal) { (progress, _)  in
                    values[index] += Int(progress)
                    group.leave()
                }
            }
            group.notify(queue: .main) {
                team.teamProgress = ArrayPile(value: values)
                CoreDataStore.saveContext()
                SessionManager.current.updateUsersTeam()
            }
        }
    }

    static func progress(for team: Team, on goal: Goal, completion: @escaping ((Double, Double) -> Void)) {
        guard UserManager.getLoggedUser()?.team == team else { return }
        let manager = HealthStoreManager()
        let serviceType = HealthStoreService.type(forTag: goal.activityType)
        manager.quantitySumSinceLastUpdate(of: serviceType) { (results) in
            let amount = GoalsManager.progressAmount(results, for: serviceType)
            completion(amount, Double(goal.requiredAmount()))
        }
    }
}
