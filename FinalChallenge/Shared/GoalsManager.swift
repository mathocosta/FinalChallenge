//
//  GoalsManager.swift
//  FinalChallenge
//
//  Created by Martônio Júnior on 04/09/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import Foundation
import CoreData
import HealthKit

class GoalsManager: NSObject {
    static func add(goal: Goal, to: User) {
        guard let amountTimedGoals = to.goalPile?.count else {
            return
        }
        if amountTimedGoals < 3 {
            to.goalPile?.append(Int(goal.id))
        }
        CoreDataManager.saveContext()
    }

    static func getCurrentTimedGoals(of user: User) -> [Goal] {
        guard let currentGoals = user.currentGoals
            else { return [] }
        let resultsData = GoalsManager.getGoals(withIDs: currentGoals)
        let goals: [Goal] = resultsData.map { (arg) -> Goal in
            let (key, value) = arg
            return Goal(id: Int(key) ?? -1, goalInfo: value, userAmount: 1)
        }
        //request.predicate = NSPredicate(format: "%goal.id IN", currentGoals)
        //let results = CoreDataManager.fetch(request)
        return goals
    }

    static func removeTimedGoals(from user: User) {
        var goals = GoalsManager.getCurrentTimedGoals(of: user)
        GoalsManager.removeTimedGoals(timedGoals: &goals, sendToPile: &user.goalPile)
    }

    static func removeTimedGoals( timedGoals goals: inout [Goal], sendToPile pile: inout [Int]?) {
        goals = []
        for goal in goals {
            pile?.append(goal.id)
        }
    }

    static func getAllGoalInfo() -> [String: [String: Any]] {
        guard let data = Bundle.main.contentsOfPList(fileName: "Goals") as? [String: [String: Any]] else {
            return [:]
        }
        return data
    }

    static func getGoals(withIDs ids: [Int]) -> [String: [String: Any]] {
        return GoalsManager.getAllGoalInfo().filter { (arg) -> Bool in
            let (key, _) = arg
            return ids.contains(Int(key) ?? -1)
        }
    }

    static func getGoalInfo(withID id: Int) -> [String: Any] {
        let data = GoalsManager.getAllGoalInfo()
        guard let goalInfo = data["\(id)"] else { return [:] }
        return goalInfo
    }

    static func amountOfGoals() -> Int {
        let data = Bundle.main.contentsOfPList(fileName: "Goals")
        return data.count
    }
    
    static func selectNewTimedGoals(fromPile goalPile: [Int]) -> [Int] {
        var chosenGoals: [Int] = []
        var randomPile: [Int] = Array(0..<GoalsManager.amountOfGoals()).shuffled()
        
        for index in 0..<randomPile.count {
            let item = randomPile[index]
            if !goalPile.contains(item) {
                chosenGoals.append(item)
            }
            
            // If all 3 weekly goals were selected
            if chosenGoals.count == 3 {
                return chosenGoals
            }
        }
        
        // If is unable to get all goals, reset the pile and grab some new ones
        return chosenGoals + randomPile[chosenGoals.count...2]
    }

    @discardableResult
    static func setNewTimedGoals(for user: User) -> [Int] {
        guard let goalPile = user.goalPile else {
            user.goalPile = []
            return Array(0...2)
        }
        let chosenGoals = GoalsManager.selectNewTimedGoals(fromPile: goalPile)
        user.goalPile?.append(contentsOf: chosenGoals)
        return chosenGoals
    }
}

// MARK: Classes and enums below ONLY for test purposes

struct Goal {
    let id: Int
    let title: String
    let difficulty: Difficulty
    let rewardAmount: Int
    let activityCoeficient: Double
    let dailyReset: Bool
    let amountOfUsers: Int

    init(id: Int, goalInfo: [String: Any], userAmount: Int) {
        self.id = id
        self.title = goalInfo["title"] as? String ?? "Sem título"
        self.difficulty = Difficulty(rawValue: goalInfo["difficulty"] as? Int ?? 0) ?? .easy
        self.rewardAmount = goalInfo["rewardAmount"] as? Int ?? 0
        self.activityCoeficient = HKQuantityTypeIdentifier.type(forTag:
            goalInfo["parameter"] as? String ?? "").balanceValue()
        self.dailyReset = goalInfo["dailyReset"] as? Bool ?? false
        self.amountOfUsers = userAmount
    }

    init(id: Int, forAmountofPeople amount: Int) {
        let goalInfo = GoalsManager.getGoalInfo(withID: id)
        self.init(id: id, goalInfo: goalInfo, userAmount: amount)
    }

    init(id: Int, title: String, difficulty: Difficulty, rewardAmount: Int,
         activityCoeficient: Double, dailyReset: Bool, amountOfUsers: Int = 1) {
        self.id = id
        self.title = title
        self.difficulty = difficulty
        self.rewardAmount = rewardAmount
        self.activityCoeficient = activityCoeficient
        self.dailyReset = dailyReset
        self.amountOfUsers = amountOfUsers
    }

    func requiredAmount() -> Int {
        let activityRewardAmount = activityCoeficient * Double(rewardAmount * amountOfUsers)
        return Int(activityRewardAmount/Double((dailyReset ? 10.0 : 1.0)*difficulty.value()))
    }
}

enum Difficulty: Int {
    case easy = 0, medium, hard

    func value() -> Double {
        switch self {
        case .easy:
            return 0.7
        case .medium:
            return 1.0
        case .hard:
            return 1.3
        }
    }
}
