//
//  Goal.swift
//  FinalChallenge
//
//  Created by Martônio Júnior on 09/09/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import Foundation
import HealthKit

struct Goal {

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

    let id: Int
    let title: String
    let difficulty: Goal.Difficulty
    let rewardAmount: Int
    let activityCoeficient: Double
    let activityType: String
    let dailyReset: Bool
    let amountOfUsers: Int

    init(id: Int, goalInfo: [String: Any], userAmount: Int) {
        self.id = id
        self.title = goalInfo["title"] as? String ?? "Sem título"
        self.difficulty = Difficulty(rawValue: goalInfo["difficulty"] as? Int ?? 0) ?? .easy
        self.rewardAmount = goalInfo["rewardAmount"] as? Int ?? 0
        self.activityType = goalInfo["parameter"] as? String ?? ""
        self.activityCoeficient = HealthStoreService.type(forTag: activityType).balanceValue
        self.dailyReset = goalInfo["dailyReset"] as? Bool ?? false
        self.amountOfUsers = userAmount
    }

    init(id: Int, forAmountofPeople amount: Int) {
        let goalInfo = GoalsManager.getGoalInfo(withID: id)
        self.init(id: id, goalInfo: goalInfo, userAmount: amount)
    }

    init(id: Int, title: String, difficulty: Difficulty, rewardAmount: Int, activityType: String,
         activityCoeficient: Double, dailyReset: Bool, amountOfUsers: Int = 1) {
        self.id = id
        self.title = title
        self.difficulty = difficulty
        self.rewardAmount = rewardAmount
        self.activityType = activityType
        self.activityCoeficient = activityCoeficient
        self.dailyReset = dailyReset
        self.amountOfUsers = amountOfUsers
    }

    func requiredAmount() -> Int {
        let activityRewardAmount = activityCoeficient * Double(rewardAmount * amountOfUsers)
        return Int(activityRewardAmount/Double((dailyReset ? 10.0 : 1.0)*difficulty.value()))
    }
}
