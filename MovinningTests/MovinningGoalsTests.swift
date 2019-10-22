//
//  MovinningGoalsTests.swift
//  MovinningTests
//
//  Created by Martônio Júnior on 08/10/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

@testable import Movinning
import XCTest

class MovinningGoalsTest: XCTestCase {
    var goals: [Goal] = []

    override func setUp() {
        for goalInfo in GoalsManager.getAllGoalInfo() {
            goals.append(Goal(id: Int(goalInfo.key) ?? -1, goalInfo: goalInfo.value, userAmount: 1))
        }
        goals.sort { (g1, g2) -> Bool in
            return g1.id < g2.id
        }
    }

    override func tearDown() {
        goals = []
    }

    func test_goal_requiredAmounts() {
        let requiredAmounts = [
            5000, // passos em um dia
            20_000, // metros
            11_100, // passos em um dia
            8000, // metros em um dia
            75_000, // passos

            // Ciclismo
            4_940, // metros em um dia
            14_820, // metros
            9_880, // metros em um dia
            29_900, // metros
            20_000, // metros em um dia
            60_000, // metros

            // Strength Training (Functional and Traditional)
            50, // minutos
            20, // minutos em um dia
            90, // minutos
            40, // minutos em um dia
            110, // minutos

            // Futebol
            10, // minutos em um dia
            40, // minutos em um dia
            80, // minutos
            130, // minutos

            // Cricket (*)
            50, // minutos em um dia
            100, // minutos
            350, // minutos em um dia
            340, // minutos

            // (Field) Hockey (*)
            10, // minutos em um dia
            30, // minutos
            120, // minutos em um dia
            80, // minutos

            // Tennis
            30, // minutos
            60, // minutos
            60, // minutos em um dia
            180, // minutos

            // Volleyball
            60, // minutos em um dia
            120, // minutos
            120, // minutos em um dia
            360, // minutos

            // Table Tennis
            20, // minutos
            10, // minutos em um dia
            80, // minutos
            120, // minutos em um dia

            // Basketball
            30, // minutos em um dia
            90, // minutos
            90, // minutos em um dia
            120, // minutos

            // Baseball (US)
            50, // minutos em um dia
            170, // minutos
            170, // minutos em um dia
            290, // minutos

            // Rugby (US)
            20, // minutos em um dia
            30, // minutos
            70, // minutos em um dia
            180, // minutos

            // Golf
            20, // minutos em um dia
            50, // minutos
            110, // minutos em um dia
            360, // minutos

            // Swimming
            480, // braçadas
            710, // braçadas
            1170, // braçadas em um dia
            3500 // braçadas
        ]

        for goal in goals {
            XCTAssert(goal.requiredAmount() == requiredAmounts[goal.id])
            if goal.requiredAmount() != requiredAmounts[goal.id] {
                print("\(goal.requiredAmount()) / \(requiredAmounts[goal.id])")
            }
        }
    }
    
    func test_goal_initWithoutGoalInfo() {
        let goal = Goal(id: 1, goalInfo: [:], userAmount: 1)
        XCTAssert(goal.title == "Sem título")
        XCTAssert(goal.difficulty == .easy)
        XCTAssert(goal.rewardAmount == 0)
        XCTAssert(goal.dailyReset == false)
        XCTAssert(goal.id == 1)
        XCTAssert(goal.activityType == "")
        XCTAssert(goal.activityCoeficient == 50.0)
    }
    
    func test_goal_initWithAllInfo() {
        let goal = Goal(id: 100, title: "Um título", difficulty: .easy, rewardAmount: 100, activityType: "type", activityCoeficient: 50.0, dailyReset: true, amountOfUsers: 2)
        XCTAssert(goal.id == 100)
        XCTAssert(goal.title == "Um título")
        XCTAssert(goal.difficulty == .easy)
        XCTAssert(goal.rewardAmount == 100)
        XCTAssert(goal.activityType == "type")
        XCTAssert(goal.activityCoeficient == 50.0)
        XCTAssert(goal.dailyReset == true)
        XCTAssert(goal.amountOfUsers == 2)
    }
}
