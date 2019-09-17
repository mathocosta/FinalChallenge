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
        // FIXME: Isso quebra se chamar o current antes de criar um usuário, precisa ser colocado em outro lugar
//        self.loggedUser = UserManager.getLoggedUser()
//        if self.loggedUser.goalPile == nil || self.loggedUser.goalPile?.isEmpty == true {
//            GoalsManager.setNewTimedGoals(for: self.loggedUser)
//        }
    }

    /// Retorna o usuário logado no app. Caso não exista, retorna "nil"
    static func getLoggedUser() -> User? {
        let request = NSFetchRequest<User>(entityName: "User")
        let users = CoreStataStore.fetch(request)

        guard let user = users.first else { return nil }

        return user
    }

    static func add(points: Int, to user: User) {
        user.points += Int32(points)
        if let team = user.team {
            TeamManager.updateAmountOfPoints(for: team)
        }
        CoreStataStore.saveContext()
    }

    static func changeGoals(for user: User, at date: Date = Date()) {
        GoalsManager.removeAllTimedGoals(from: user)
        GoalsManager.setNewTimedGoals(for: user, at: date)
        CoreStataStore.saveContext()
    }

    static func createUser(with info: [String: Any?]) -> User {
        let user = User(context: CoreStataStore.context)
        user.id = (info["id"] as? UUID) ?? UUID()
        user.recordMetadata = info["recordMetadata"] as? Data
        user.name = info["name"] as? String
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
        CoreStataStore.saveContext()
    }

    static func logout(user: User) {
        CoreStataStore.context.delete(user)
        CoreStataStore.saveContext()
    }

    func simulateAppInteraction() {
        let steps = Int.random(in: 0...1000)
        let points = PointManager.points(forSteps: Double(steps))
        UserManager.add(points: points, to: UserManager.current.loggedUser)
    }
}
