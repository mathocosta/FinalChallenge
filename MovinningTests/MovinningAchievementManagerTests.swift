//
//  MovinningAchievementManagerTests.swift
//  MovinningTests
//
//  Created by Martônio Júnior on 25/11/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import XCTest
@testable import Movinning

class MovinningAchievementManagerTests: XCTestCase {
    var user: User!
    var achievement: Achievement!

    override func setUp() {
        user = User(context: CoreDataStore.context)
        user.achievements = GoalPile(value: [0])
        achievement = Achievement(id: 3)
    }

    override func tearDown() {
        CoreDataStore.context.delete(user)
    }

    func test_achievementmanager_addAchievementToUser() {
        AchievementManager.add(achievement: achievement, to: user)
        guard let achievements = user.achievements else {
            XCTAssert(false)
            return
        }
        XCTAssert(achievements.value.count == 2)
        XCTAssert(achievements.value.contains(0))
        XCTAssert(achievements.value.contains(3))
    }

    func test_achievementmanager_achievementsToCompleteOfUser() {
        let achievements = AchievementManager.achievementsToComplete(of: user)
        XCTAssert(achievements.count == AchievementManager.numberOfAchievements() - 1)
        XCTAssert(!achievements.contains(where: { return $0.id == 0 }))
    }

    func test_achievementmanager_completedAchievementsOfUser() {
        let achievements = AchievementManager.completedAchievements(of: user)
        XCTAssert(achievements.count == 1)
        XCTAssert(achievements.contains(where: { return $0.id == 0 }))
    }

    func test_achievementmanager_inProgressAchievementsOfUser() {
        let achievements = AchievementManager.inProgressAchievements(of: user)
        XCTAssert(achievements.count == 1)
        XCTAssert(achievements.contains(where: { return $0.id == 0 }))
    }

    func test_achievementmanager_getAllPossibleAchievements() {
        let achievements = AchievementManager.getAllPossibleAchievements()
        XCTAssert(achievements.count == AchievementManager.numberOfAchievements())
        for id in 0..<AchievementManager.numberOfAchievements() {
            XCTAssert(achievements.contains(where: { return $0.id == id }))
        }
    }

    func test_achievementmanager_getAchievementsWithIDs() {
        let achievements = AchievementManager.getAchievements(withIDs: [5, 10, 15])
        XCTAssert(achievements.count == 3)
        XCTAssert(achievements.contains(where: { return $0.id == 5 }))
        XCTAssert(achievements.contains(where: { return $0.id == 10 }))
        XCTAssert(achievements.contains(where: { return $0.id == 15 }))
    }

    func test_achievementmanager_markCompletedAchievementOfUser() {
        AchievementManager.markCompleted(achievement: achievement, from: user)
        guard let achievements = user.achievements else {
            XCTAssert(false)
            return
        }
        XCTAssert(achievements.value.count == 2)
        XCTAssert(achievements.value.contains(0))
        XCTAssert(achievements.value.contains(3))
    }

    func test_achievementmanager_getAllAchievementInfo() {
        for (_, dataValue) in AchievementManager.getAllAchievementInfo() {
            guard let rank = dataValue["ranking"] as? String,
                let type = dataValue["type"] as? String else {
                    XCTAssert(false)
                    return
            }
            XCTAssert(Ranking(rawValue: rank) != nil)
            XCTAssert(Sport(rawValue: type) != nil)
        }
    }

    func test_achievementmanager_getAchievementData() {
        let achievements = AchievementManager.getAchievementData(withIDs: [22, 34, 55])
        for (_, dataValue) in achievements {
            guard let ranking = dataValue["ranking"] as? String,
                let type = dataValue["type"] as? String else {
                    XCTAssert(false)
                    return
            }
            XCTAssert(Ranking(rawValue: ranking) != nil)
            XCTAssert(Sport(rawValue: type) != nil)
        }
    }

    func test_achievementmanager_getAchievementInfoWithID() {
        let data = AchievementManager.getAchievementInfo(withID: 17)
        guard let type = data["type"] as? String,
            let rank = data["ranking"] as? String else {
                XCTAssert(false)
                return
        }
        XCTAssert(Ranking(rawValue: rank) == Ranking.lunatic)
        XCTAssert(Sport(rawValue: type) == Sport.soccer)
    }

    func test_achievementmanager_numberOfAchievements() {
        XCTAssert(AchievementManager.numberOfAchievements() == 6 * Sport.allCases.count)
    }
}
