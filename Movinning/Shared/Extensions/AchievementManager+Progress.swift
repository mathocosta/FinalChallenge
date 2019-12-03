//
//  AchievementManager+Progress.swift
//  Movinning
//
//  Created by Martônio Júnior on 21/11/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import Foundation
import HealthKit

extension AchievementManager {
    static func checkForCompletedAchievements(for user: User) {
        let achievements = AchievementManager.achievementsToComplete(of: user).filter {
            return HealthStoreService.allAllowedSports.contains($0.achievementType)
        }
        for achievement in achievements {
            progress(for: user, on: achievement) { (progress, required) in
                if progress > required {
                    AchievementManager.markCompleted(achievement: achievement, from: user)
                }
            }
        }
        CoreDataStore.saveContext()
    }

    static func progress(for user: User, on achievement: Achievement,
                         completion: @escaping ((Double, Double) -> Void)) {
        guard HealthStoreService.allAllowedSports.contains(achievement.achievementType) else { return }
        let manager = HealthStoreManager()

        guard let firstTimeDate = UserDefaults.standard.firstTimeOpened else { return }
        let serviceTypes = achievement.achievementType.services()

        var progressAmount = 0.0
        var goalAmount = 0.0
        let groupQuery = DispatchGroup()
        for serviceType in serviceTypes {
            groupQuery.enter()
            manager.quantitySum(from: firstTimeDate, of: serviceType) { (results) in
                progressAmount += GoalsManager.progressAmount(results, for: serviceType)
                goalAmount = Double(achievement.requiredAmount())
                groupQuery.leave()
            }
        }

        groupQuery.notify(queue: .main) {
            completion(progressAmount, goalAmount)
        }
    }
}
