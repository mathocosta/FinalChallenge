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
    }

    // Function needs refactoring later
    static func getLoggedUser() -> User {
        let request = NSFetchRequest<User>(entityName: "User")
        let users = CoreDataManager.fetch(request)
        guard let user = users.first else {
            let dummyUser = UserManager.createDummyUser()
            CoreDataManager.saveContext()
            return dummyUser
        }
        return user
    }

    static func update(_ user: User, addPoints points: Int) {
        user.points += Int32(points)
        CoreDataManager.saveContext()
    }

    static func createNewUser(name: String, email: String) -> User {
        let user = User(context: CoreDataManager.context)
        user.id = UUID()
        user.name = name
        user.email = email
        user.points = 0
        user.goalPile = GoalPile(value: [])
        return user
    }

    // Use these functions below ONLY for tests

    static func createDummyUser() -> User {
        return createNewUser(name: "User", email: "user@app.com")
    }

    func simulateAppInteraction() {
        let steps = Int.random(in: 0...1000)
        let points = PointManager.points(forSteps: Double(steps))
        UserManager.update(UserManager.current.loggedUser, addPoints: points)
    }
}
