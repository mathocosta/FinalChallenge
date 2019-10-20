//
//  MovinningGoalsManagerTests.swift
//  MovinningTests
//
//  Created by Martônio Júnior on 18/10/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

@testable import Movinning
import XCTest

class MovinningGoalsManager: XCTestCase {
    var testUser: User!

    override func setUp() {
        testUser = User(context: CoreDataStore.context)
        testUser.currentGoals = GoalPile(value: [5, 7])
        testUser.currentGoals = testUser.currentGoals!.mark(5)
        testUser.goalPile = GoalPile(value: [8, 9, 10])
    }

    override func tearDown() {
        CoreDataStore.context.delete(testUser)
        UserDefaults.standard.goalUpdateTime = nil
    }

    func test_goalsmanager_addGoalToUser() {
        let testGoal = Goal(id: 1, forAmountofPeople: 1)
        GoalsManager.add(goal: testGoal, to: testUser)
        guard let currentGoals = testUser.currentGoals else {
            XCTAssert(false)
            return
        }
        XCTAssert(!currentGoals.isEmpty)
        XCTAssert(currentGoals.value.count == 3)
        XCTAssert(currentGoals.value.contains(1))
    }

    func test_goalsmanager_currentTimedGoalsOfUser() {
        let goals = GoalsManager.currentTimedGoals(of: testUser)
        XCTAssert(goals.count == 2)
        XCTAssert(goals.contains(where: { (goal) in
            return goal.id == 5
        }))
        XCTAssert(goals.contains(where: { (goal) in
            return goal.id == 7
        }))
    }

    func test_goalsmanager_completedGoalsOfUser() {
        let goals = GoalsManager.completedGoals(of: testUser)
        XCTAssert(goals.count == 1)
        XCTAssert(goals.contains(where: { (goal) in
            return goal.id == 5
        }))
    }

    func test_goalsmanager_inProgressGoalsOfUser() {
        let goals = GoalsManager.inProgressGoals(of: testUser)
        XCTAssert(goals.count == 1)
        XCTAssert(goals.contains(where: { (goal) in
            return goal.id == 7
        }))
    }

    func test_goalsmanager_getGoalsWithIDs() {
        let goals = GoalsManager.getGoals(withIDs: [3, 4, 5])
        XCTAssert(goals.count == 3)
        XCTAssert(goals.contains(where: { (goal) in
            return goal.id == 3
        }))
        XCTAssert(goals.contains(where: { (goal) in
            return goal.id == 4
        }))
        XCTAssert(goals.contains(where: { (goal) in
            return goal.id == 5
        }))
    }

    func test_goalsmanager_markCompletedGoalOfUser() {
        guard let goal = GoalsManager.getGoals(withIDs: [7]).first else {
            XCTAssert(false)
            return
        }
        GoalsManager.markCompleted(goal: goal, from: testUser)
        guard let currentGoals = testUser.currentGoals else {
            XCTAssert(false)
            return
        }
        XCTAssert(currentGoals.unmarkedGoals().count == 0)
        XCTAssert(currentGoals.markedValues.count == 2)
        XCTAssert(currentGoals.markedValues.contains(7))
    }

    func test_goalsmanager_removeAllTimedGoalsOfUser() {
        GoalsManager.removeAllTimedGoals(from: testUser)
        guard let goalPile = testUser.goalPile,
            let currentGoals = testUser.currentGoals else {
                XCTAssert(false)
                return
        }
        XCTAssert(currentGoals.isEmpty)
        XCTAssert(goalPile.value.count == 5)
        XCTAssert(goalPile.value.contains(5))
        XCTAssert(goalPile.value.contains(7))
    }

    func test_goalsmanager_getAllGoalInfo() {
        let info = GoalsManager.getAllGoalInfo()
        XCTAssert(info.count == GoalsManager.amountOfGoals())
        for (_, goal) in info {
            XCTAssert(goal.count == 5)
            XCTAssert(goal["title"] is String)
            XCTAssert(goal["parameter"] is String)
            XCTAssert(goal["difficulty"] is NSNumber)
            XCTAssert(goal["rewardAmount"] is NSNumber)
            XCTAssert(goal["dailyReset"] is Bool)
        }
    }

    func test_goalsmanager_getGoalDataWithIDs() {
        let info = GoalsManager.getGoalData(withIDs: [0, 1])
        XCTAssert(info.count == 2)
        for (_, goal) in info {
            XCTAssert(goal.count == 5)
            XCTAssert(goal["title"] is String)
            XCTAssert(goal["parameter"] is String)
            XCTAssert(goal["difficulty"] is NSNumber)
            XCTAssert(goal["rewardAmount"] is NSNumber)
            XCTAssert(goal["dailyReset"] is Bool)
        }
    }

    func test_goalsmanager_getGoalInfoWithID() {
        let info = GoalsManager.getGoalInfo(withID: 0)
        let goal = Goal(id: 0, goalInfo: info, userAmount: 1)
        XCTAssert(info.count == 5)
        XCTAssert(goal.title != "")
        XCTAssert(goal.activityType == "stepCount")
        XCTAssert(goal.difficulty == .medium)
        XCTAssert(goal.rewardAmount == 1000)
        XCTAssert(goal.dailyReset)
    }

    func test_goalsmanager_amountOfGoals() {
        XCTAssert(GoalsManager.amountOfGoals() == 60)
    }

    func test_goalsmanager_selectNewTimedGoalsFromGoalPile() {
        guard var goalPile = testUser.goalPile,
            let currentGoals = testUser.currentGoals else {
            XCTAssert(false)
            return
        }
        for item in currentGoals.value {
            goalPile = goalPile.add(item)
        }
        let goals = GoalsManager.selectNewTimedGoals(fromPile: goalPile)
        XCTAssert(goals.count == 3)
        XCTAssert(!goals.contains(where: { (id) in
            return id == 5
        }))
        XCTAssert(!goals.contains(where: { (id) in
            return id == 7
        }))
        XCTAssert(!goals.contains(where: { (id) in
            return id == 8
        }))
        XCTAssert(!goals.contains(where: { (id) in
            return id == 9
        }))
        XCTAssert(!goals.contains(where: { (id) in
            return id == 10
        }))
    }

    func test_goalsmanager_setNewTimedGoalsForUserAtDate() {
        let now = Date()
        GoalsManager.setNewTimedGoals(for: testUser, at: now)

        guard let goalPile = testUser.goalPile,
            let currentGoals = testUser.currentGoals else {
                XCTAssert(false)
                return
        }

        XCTAssert(UserDefaults.standard.goalUpdateTime == now)
        XCTAssert(currentGoals.value.count == 3)
        XCTAssert(!currentGoals.value.contains(5))
        XCTAssert(!currentGoals.value.contains(7))

        XCTAssert(goalPile.value.count == 5)
        XCTAssert(goalPile.value.contains(5))
        XCTAssert(goalPile.value.contains(7))
        XCTAssert(goalPile.value.contains(8))
        XCTAssert(goalPile.value.contains(9))
        XCTAssert(goalPile.value.contains(10))
    }

    func test_goalsmanager_selectNewTimedGoalsFromFullGoalPile() {
        testUser.currentGoals = GoalPile(value: [0, 1, 2])
        testUser.goalPile = GoalPile(value: Set(Array(4..<GoalsManager.amountOfGoals())))
        guard var goalPile = testUser.goalPile,
            let currentGoals = testUser.currentGoals else {
            XCTAssert(false)
            return
        }
        for item in currentGoals.value {
            goalPile = goalPile.add(item)
        }
        let goals = GoalsManager.selectNewTimedGoals(fromPile: goalPile)
        XCTAssert(goals.count == 3)
    }

    func test_goalsmanager_setNewTimedGoalsForUserAtDateFullPile() {
        testUser.currentGoals = GoalPile(value: [0, 1, 2])
        testUser.goalPile = GoalPile(value: Set(Array(4..<GoalsManager.amountOfGoals())))
        let now = Date()
        GoalsManager.setNewTimedGoals(for: testUser, at: now)

        guard let goalPile = testUser.goalPile,
            let currentGoals = testUser.currentGoals else {
                XCTAssert(false)
                return
        }

        XCTAssert(UserDefaults.standard.goalUpdateTime == now)
        XCTAssert(currentGoals.value.count == 3)
        XCTAssert(goalPile.value.count == 0)
    }

    func test_goalsmanager_checkForCompletedDailyGoals() {
        testUser.currentGoals = testUser.currentGoals?.add(2)
        GoalsManager.checkForCompletedGoals(for: testUser)
    }
}
