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
    static let current = UserManager()

    override init() {
        super.init()
    }

    /// Retorna o usuário logado no app. Caso não exista, retorna "nil"
    static func getLoggedUser() -> User? {
        let request = NSFetchRequest<User>(entityName: "User")
        let users = CoreDataStore.fetch(request)

        guard let user = users.first else { return nil }

        return user
    }

    static func add(points: Int, to user: User) {
        PointManager.add(points, to: user)
        if let team = user.team {
            TeamManager.updateAmountOfPoints(for: team)
        }
        CoreDataStore.saveContext()
    }

    static func changeGoals(for user: User, at date: Date = Date()) {
        GoalsManager.checkForCompletedGoals(for: user)
        GoalsManager.removeAllTimedGoals(from: user)
        GoalsManager.setNewTimedGoals(for: user, at: date)
        CoreDataStore.saveContext()
    }

    static func createUser(with info: [String: Any?]) -> User {
        let user = User(context: CoreDataStore.context)
        user.id = (info["id"] as? UUID) ?? UUID()
        user.recordMetadata = info["recordMetadata"] as? Data
        user.firstName = info["firstName"] as? String
        user.lastName = info["lastName"] as? String
        user.email = info["email"] as? String
        user.points = (info["points"] as? Int32) ?? 0
        user.goalPile = GoalPile(value: [])
        user.currentGoals = GoalPile(value: [])

        if let imageData = info["photo"] as? Data {
            user.photo = imageData
        }

        return user
    }

    static func update(recordMetadata: Data, of user: User) {
        user.recordMetadata = recordMetadata
    }

    static func logout(user: User) {
        CoreDataStore.context.delete(user)
        CoreDataStore.saveContext()
    }
}
