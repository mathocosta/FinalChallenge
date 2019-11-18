//
//  MovinningExerciseIntensityTests.swift
//  MovinningTests
//
//  Created by Martônio Júnior on 13/11/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import XCTest
import HealthKit
@testable import Movinning

class MovinningExerciseIntensityTests: XCTestCase {

    override func setUp() {

    }

    override func tearDown() {

    }

    func test_exerciseIntensity_amount() {
        XCTAssert(ExerciseIntensity.halfHour.amount() == 30)
        XCTAssert(ExerciseIntensity.oneHour.amount() == 60)
        XCTAssert(ExerciseIntensity.oneAndAHalfHour.amount() == 90)
        XCTAssert(ExerciseIntensity.twoHours.amount() == 120)
        XCTAssert(ExerciseIntensity.twoAndAHalfHours.amount() == 150)
    }

    func test_exerciseIntensity_recommendedAmountForService() {
        XCTAssert(ExerciseIntensity.halfHour.recommendedAmount(for: .hockey) == 30)
        XCTAssert(ExerciseIntensity.oneHour.recommendedAmount(for: .cycling) == 24000)
        XCTAssert(ExerciseIntensity.oneAndAHalfHour.recommendedAmount(for: .distanceWalkingRunning) == 9000)
        XCTAssert(ExerciseIntensity.twoHours.recommendedAmount(for: .stepCount) == 13200)
        XCTAssert(ExerciseIntensity.twoAndAHalfHours.recommendedAmount(for: .swimming) == 7500)
    }

    func test_exerciseIntensity_allTypes() {
        XCTAssert(ExerciseIntensity.allTypes == Set(ExerciseIntensity.allCases))
    }

    func test_exerciseIntensity_title() {
        XCTAssert(ExerciseIntensity.halfHour.title() == "30min")
        XCTAssert(ExerciseIntensity.oneHour.title() == "60min")
        XCTAssert(ExerciseIntensity.oneAndAHalfHour.title() == "90min")
        XCTAssert(ExerciseIntensity.twoHours.title() == "120min")
        XCTAssert(ExerciseIntensity.twoAndAHalfHours.title() == "150min")
    }

    func test_exerciseIntensity_index() {
        XCTAssert(ExerciseIntensity.halfHour.index() == 0)
        XCTAssert(ExerciseIntensity.oneHour.index() == 1)
        XCTAssert(ExerciseIntensity.oneAndAHalfHour.index() == 2)
        XCTAssert(ExerciseIntensity.twoHours.index() == 3)
        XCTAssert(ExerciseIntensity.twoAndAHalfHours.index() == 4)
    }

    func test_exerciseIntensity_intensityForIndex() {
        XCTAssert(ExerciseIntensity.intensity(for: 0) == .halfHour)
        XCTAssert(ExerciseIntensity.intensity(for: 1) == .oneHour)
        XCTAssert(ExerciseIntensity.intensity(for: 2) == .oneAndAHalfHour)
        XCTAssert(ExerciseIntensity.intensity(for: 3) == .twoHours)
        XCTAssert(ExerciseIntensity.intensity(for: 4) == .twoAndAHalfHours)
        XCTAssert(ExerciseIntensity.intensity(for: 5) == .twoAndAHalfHours)
    }

    func test_exerciseIntensity_recommendGoal() {
        let goals = GoalsManager.getGoals(withIDs: [11, 26, 32, 44, 58]).sorted { (g1, g2) -> Bool in
            return g1.id < g2.id
        }
        let recommendGoalA = [true, true, true, true, true]
        let recommendGoalB = [false, false, false, true, true]
        let recommendGoalC = [false, true, true, true, true]
        let recommendGoalD = [false, true, true, true, true]
        let recommendGoalE = [true, true, true, true, true]
        let recommendGoals = [recommendGoalA, recommendGoalB, recommendGoalC, recommendGoalD, recommendGoalE]
        for index in 0..<goals.count {
            let goal = goals[index]
            let recommendations = recommendGoals[index]
            XCTAssert(ExerciseIntensity.halfHour.recommend(goal) == recommendations[0])
            XCTAssert(ExerciseIntensity.oneHour.recommend(goal) == recommendations[1])
            XCTAssert(ExerciseIntensity.oneAndAHalfHour.recommend(goal) == recommendations[2])
            XCTAssert(ExerciseIntensity.twoHours.recommend(goal) == recommendations[3])
            XCTAssert(ExerciseIntensity.twoAndAHalfHours.recommend(goal) == recommendations[4])
        }
    }
}
