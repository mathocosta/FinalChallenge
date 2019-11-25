//
//  MovinningAchievementTests.swift
//  MovinningTests
//
//  Created by Martônio Júnior on 25/11/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import XCTest
@testable import Movinning

class MovinningAchievementTests: XCTestCase {

    override func setUp() {}

    override func tearDown() {}

    func test_achievement_convenienceInit() {
        let achievement = Achievement(id: 8)
        XCTAssert(achievement.id == 8)
        XCTAssert(achievement.ranking == .expert)
        XCTAssert(achievement.achievementType == .running)
    }

    func test_achievement_initWithNoAchievementInfo() {
        let achievement = Achievement(id: -1, achievementInfo: [:])
        XCTAssert(achievement.id == -1)
        XCTAssert(achievement.ranking == .fan)
        XCTAssert(achievement.achievementType == .walking)
    }

    func test_achievement_getTag() {
        let achievement = Achievement(id: 22)
        XCTAssert(achievement.getTag() == "Cycling Champion")
    }

    func test_achievement_getTitle() {
        let achievement = Achievement(id: 64)
        XCTAssert(achievement.getTitle() == NSLocalizedString("Basketball Champion Title", comment: ""))
    }

    func test_achievement_getDescription() {
        let achievement = Achievement(id: 19)
        XCTAssert(achievement.getDescription() == NSLocalizedString("Cycling Defender Description", comment: ""))
    }

    func test_achievement_requiredAmount() {
        let achievement = Achievement(id: 81)
        XCTAssert(achievement.requiredAmount() == 2400)
    }
}
