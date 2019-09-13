//
//  UserManager.swift
//  FinalChallenge
//
//  Created by Martônio Júnior on 03/09/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit
import CoreData

class UserManager: NSObject {
    var loggedUser: User!
    static let current = UserManager()

    override init() {
        super.init()
        self.loggedUser = UserManager.getLoggedUser()
        if self.loggedUser.goalPile == nil || self.loggedUser.goalPile?.isEmpty == true {
            GoalsManager.setNewTimedGoals(for: self.loggedUser)
        }
    }

    // Function needs refactoring later
    static func getLoggedUser() -> User? {
        let request = NSFetchRequest<User>(entityName: "User")
        let users = CoreDataManager.fetch(request)

        guard let user = users.first else { return nil }

        return user
    }

    static func update(_ user: User, addPoints points: Int) {
        user.points += Int32(points)
        if let team = user.team {
            TeamManager.updateAmountOfPoints(for: team)
        }
        CoreDataManager.saveContext()
    }

    static func changeGoals(for user: User, at date: Date = Date()) {
        GoalsManager.removeAllTimedGoals(from: user)
        GoalsManager.setNewTimedGoals(for: user)
        UserDefaults.standard.set(date, forKey: "GoalUpdateTime")
        CoreDataManager.saveContext()
    }

    @discardableResult
    static func createNewUser(name: String) -> User {
        let user = User(context: CoreDataManager.context)
        user.id = UUID()
        user.name = name
        user.email = ""
        user.points = 0
        user.goalPile = GoalPile(value: [])
        user.currentGoals = GoalPile(value: [])
        return user
    }

    static func logout(user: User) {
        CoreDataManager.context.delete(user)
        CoreDataManager.saveContext()
    }

    // Use these functions below ONLY for tests

//    static func createDummyUser() -> User {
//        return createNewUser(name: "User", email: "user@app.com")
//    }

    func simulateAppInteraction() {
        let steps = Int.random(in: 0...1000)
        let points = PointManager.points(forSteps: Double(steps))
        UserManager.update(UserManager.current.loggedUser, addPoints: points)
    }
}
