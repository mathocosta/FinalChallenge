//
//  AchievementManager.swift
//  Movinning
//
//  Created by Martônio Júnior on 13/11/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import Foundation

class AchievementManager {
    static func add(achievement: Achievement, to user: User) {
        guard user.achievements != nil else {
            return
        }
        AchievementManager.markCompleted(achievement: achievement, from: user)
        CoreDataStore.saveContext()
    }

    static func achievementsToComplete(of user: User) -> [Achievement] {
        var results = getAllPossibleAchievements()
        if let achievements = user.achievements?.value {
            results = results.filter {
                return !achievements.contains($0.id)
            }
        }
        return results
    }

    static func completedAchievements(of user: User) -> [Achievement] {
        guard let currentGoals = user.achievements?.value
            else { return [] }
        let results = getAchievements(withIDs: Array(currentGoals))
        return results
    }

    static func inProgressAchievements(of user: User) -> [Achievement] {
        guard let achievements = user.achievements?.unmarkedGoals()
            else { return [] }
        let results = getAchievements(withIDs: Array(achievements))
        return results
    }

    static func getAllPossibleAchievements() -> [Achievement] {
        return getAchievements(withIDs: Array(0...numberOfAchievements() - 1))
    }

    static func achievementsBySport() -> [Sport: [Achievement]] {
        let sports = Sport.allCases
        let achievements = getAllPossibleAchievements()

        var result: [Sport: [Achievement]] = [:]
        sports.forEach { sport in
            result[sport] = achievements.filter({ $0.achievementType == sport })
        }

        return result
    }

    static func getAchievements(withIDs ids: [Int]) -> [Achievement] {
        let resultsData = AchievementManager.getAchievementData(withIDs: ids)
        let achievements: [Achievement] = resultsData.map { (arg) -> Achievement in
            let (key, value) = arg
            return Achievement(id: Int(key) ?? -1, achievementInfo: value)
        }
        return achievements
    }

    static func markCompleted(achievement: Achievement, from user: User) {
        guard let achievements = user.achievements, !achievements.value.contains(achievement.id) else {
            return
        }
        user.achievements = achievements.add(achievement.id)
    }

    static func getAllAchievementInfo() -> [String: [String: Any]] {
        guard let data = Bundle.main.contentsOfPList(fileName: "Achievements") as? [String: [String: Any]] else {
            return [:]
        }
        return data
    }

    static func getAchievementData(withIDs ids: [Int]) -> [String: [String: Any]] {
        return AchievementManager.getAllAchievementInfo().filter { (arg) -> Bool in
            let (key, _) = arg
            return ids.contains(Int(key) ?? -1)
        }
    }

    static func getAchievementInfo(withID id: Int) -> [String: Any] {
        let data = AchievementManager.getAllAchievementInfo()
        guard let goalInfo = data["\(id)"] else { return [:] }
        return goalInfo
    }

    static func numberOfAchievements() -> Int {
        let data = Bundle.main.contentsOfPList(fileName: "Achievements")
        return data.count
    }
}
