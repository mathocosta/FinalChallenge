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
        guard let amountTimedGoals = to.goalPile?.value.count else {
            return
        }
        if amountTimedGoals < 3 {
            guard var goalPile = to.goalPile?.value else { return }
            goalPile.append(Int(goal.id))
            to.goalPile = GoalPile(value: goalPile)
        }
        CoreDataManager.saveContext()
    }

    static func getCurrentTimedGoals(of user: User) -> [Goal] {
        guard let currentGoals = user.currentGoals
            else { return [] }
        let goals = getGoals(withIDs: currentGoals.value)
        return goals
    }

    static func getGoals(withIDs ids: [Int]) -> [Goal] {
        let resultsData = GoalsManager.getGoalData(withIDs: ids)
        let goals: [Goal] = resultsData.map { (arg) -> Goal in
            let (key, value) = arg
            return Goal(id: Int(key) ?? -1, goalInfo: value, userAmount: 1)
        }
        return goals
    }

    static func removeTimedGoals(from user: User) {
        var goals = GoalsManager.getCurrentTimedGoals(of: user)
        GoalsManager.removeTimedGoals(timedGoals: &goals, sendToPile: &user.goalPile)
    }

    static func removeTimedGoals(timedGoals goals: inout [Goal], sendToPile pile: inout GoalPile?) {
        let amountOfGoals = GoalsManager.amountOfGoals()
        guard var pileIDs = pile?.value else { return }
        let pileAmount = pileIDs.count
        if pileAmount + goals.count >= amountOfGoals {
            pileIDs.removeAll()
        }
        for goal in goals {
            pileIDs.append(goal.id)
        }
        pile = GoalPile(value: pileIDs)
        goals = []
    }

    static func getAllGoalInfo() -> [String: [String: Any]] {
        guard let data = Bundle.main.contentsOfPList(fileName: "Goals") as? [String: [String: Any]] else {
            return [:]
        }
        return data
    }

    static func getGoalData(withIDs ids: [Int]) -> [String: [String: Any]] {
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

    static func selectNewTimedGoals(fromPile goalPile: GoalPile) -> [Int] {
        var chosenGoals: [Int] = []
        var randomPile: [Int] = Array(0..<GoalsManager.amountOfGoals()).shuffled()
        let copyPile = randomPile
        for index in 0..<copyPile.count {
            let item = copyPile[index]
            if !goalPile.value.contains(item) {
                chosenGoals.append(item)
                randomPile.removeAll { (ri) -> Bool in
                    return ri == item
                }
            }

            // If all 3 weekly goals were selected
            if chosenGoals.count == 3 {
                return chosenGoals
            }
        }
        randomPile = randomPile.filter({ (ri) -> Bool in
            return !chosenGoals.contains(ri)
        })
        let newGoals = chosenGoals + randomPile[chosenGoals.count...2]
        // If is unable to get all goals, reset the pile and grab some new ones
        return newGoals
    }

    @discardableResult
    static func setNewTimedGoals(for user: User) -> [Int] {
        guard let pile = user.goalPile else {
            user.goalPile = GoalPile(value: [])
            return Array(0...2)
        }
        let chosenGoals = GoalsManager.selectNewTimedGoals(fromPile: pile)
        user.currentGoals = GoalPile(value: chosenGoals)
        user.goalPile = GoalPile(value: pile.value + chosenGoals)
        return chosenGoals
    }
}
