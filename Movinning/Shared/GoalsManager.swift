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
    static func add(goal: Goal, to user: User) {
        guard let amountTimedGoals = user.currentGoals?.value.count else {
            return
        }
        if amountTimedGoals < 3 {
            guard let currentGoals = user.currentGoals else { return }
            user.currentGoals = currentGoals.add(Int(goal.id))
        }
        CoreDataStore.saveContext()
    }

    static func currentTimedGoals(of user: User) -> [Goal] {
        guard let currentGoals = user.currentGoals?.value
            else { return [] }
        let goals = getGoals(withIDs: Array(currentGoals))
        return goals
    }

    static func completedGoals(of user: User) -> [Goal] {
        guard let currentGoals = user.currentGoals?.markedValues
            else { return [] }
        let goals = getGoals(withIDs: Array(currentGoals))
        return goals
    }

    static func inProgressGoals(of user: User) -> [Goal] {
        guard let currentGoals = user.currentGoals?.unmarkedGoals()
            else { return [] }
        let goals = getGoals(withIDs: Array(currentGoals))
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

    static func markCompleted(goal: Goal, from user: User) {
        guard let currentGoals = user.currentGoals, !currentGoals.markedValues.contains(goal.id) else {
            return
        }
        user.currentGoals = currentGoals.mark(goal.id)
        UserManager.add(points: goal.rewardAmount, to: user)

    }

    static func removeAllTimedGoals(from user: User) {
        var goals = GoalsManager.currentTimedGoals(of: user)
        GoalsManager.remove(timedGoals: &goals, sendToPile: &user.goalPile)
        user.currentGoals = GoalPile(value: [])
    }

    static func remove(timedGoals goals: inout [Goal], sendToPile pile: inout GoalPile?) {
        let amountOfGoals = GoalsManager.amountOfGoals()
        guard let pileAmount = pile?.value.count else { return }
        if pileAmount + goals.count >= amountOfGoals {
            pile = GoalPile(value: [])
        }
        for goal in goals {
            pile = pile?.add(goal.id)
        }
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

    static func amountOfPossibleGoals() -> Int {
        return getRandomPile().count
    }

    static func userHasPreference(for goal: Goal) -> Bool {
        return true
    }

    static func getRandomPile() -> [Int] {
        var randomPile: [Int] = Array(0..<GoalsManager.amountOfGoals()).shuffled()
        randomPile = randomPile.filter({ (ri) -> Bool in
            let goal = Goal(id: ri, forAmountofPeople: 1)
            return GoalsManager.userHasPreference(for: goal)
        })
        return randomPile
    }

    static func selectNewTimedGoals(fromPile goalPile: GoalPile) -> [Int] {
        var chosenGoals: [Int] = []
        var randomPile: [Int] = GoalsManager.getRandomPile()
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
    static func setNewTimedGoals(for user: User, at date: Date = Date()) -> [Int] {
        if let lastGoals = user.currentGoals {
            for goal in lastGoals.value {
                user.goalPile = user.goalPile?.add(goal)
            }
        }
        var chosenGoals: [Int] = []
        if let pileCount = user.goalPile?.value.count,
            pileCount + 3 > amountOfGoals() {
            user.goalPile = GoalPile(value: [])
        }

        if let pile = user.goalPile {
            chosenGoals = GoalsManager.selectNewTimedGoals(fromPile: pile)
        } else {
            user.goalPile = GoalPile(value: [])
            chosenGoals = Array(0...2)
        }

        user.currentGoals = GoalPile(value: Set(chosenGoals))
        UserDefaults.standard.goalUpdateTime = date
        return chosenGoals
    }
}
