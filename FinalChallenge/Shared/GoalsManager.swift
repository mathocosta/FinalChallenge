//
//  GoalsManager.swift
//  FinalChallenge
//
//  Created by Martônio Júnior on 04/09/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import Foundation
import CoreData

class GoalsManager: NSObject {
    func add(goal: Goal, to: User) {
        guard let amountTimedGoals = to.goalPile?.count else {
            return
        }
        if amountTimedGoals < 3 {
            to.goalPile?.append(Int(goal.id))
        }
        CoreDataManager.saveContext()
    }

    func getCurrentTimedGoals(of user: User) -> [Goal] {
        guard let currentGoals = user.currentGoals else { return [] }
        let results = Goal.allItems.filter {_ in
            return
        }
        //request.predicate = NSPredicate(format: "%goal.id IN", currentGoals)
        //let results = CoreDataManager.fetch(request)
        return results
    }

    func removeTimedGoals(from user: User) {
        let goals = getCurrentTimedGoals(of: user)
        user.currentGoals = []
        for goal in goals {
            user.goalPile?.append(goal.id)
        }
    }

    func selectNewTimedGoals(for user: User) {

    }
}

// --MARK: Classes and enums below ONLY for test purposes
struct Goal {
    static var allItems: [Goal] = []
    let id: Int
    let title: String
    // let parameter: HealthStoreService
    let difficulty: Difficulty
    let rewardAmount: Int
    let activityCoeficient: Double
    let dailyReset: Bool
    
    init(id: Int, title: String, difficulty: Difficulty, rewardAmount: Int, activityCoeficient: Double, dailyReset: Bool) {
        self.id = id
        self.title = title
        self.difficulty = difficulty
        self.rewardAmount = rewardAmount
        self.activityCoeficient = activityCoeficient
        self.dailyReset = dailyReset
    }
    
    func quantity(for amountPeople: Int) -> Int {
        let activityRewardAmount = activityCoeficient * Double(rewardAmount)
        return activityRewardAmount*Double(difficulty.rawValue)/(dailyReset ? 10 : 1)
    }
}

enum Difficulty: Double {
    case easy = 0.7
    case medium = 1.0
    case hard = 1.3
}
