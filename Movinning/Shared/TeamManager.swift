//
//  TeamManager.swift
//  FinalChallenge
//
//  Created by Martônio Júnior on 11/09/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import Foundation
import CoreData

class TeamManager: NSObject {
    @discardableResult
    static func newTeam(named name: String, createdBy user: User) -> Team {
        let team = Team(context: CoreDataStore.context)
        team.id = UUID()
        team.name = name
        team.points = 0
        TeamManager.add(user, to: team)
        return team
    }

    static func createTeam(with info: [String: Any?]) -> Team {
        let team = Team(context: CoreDataStore.context)
        team.id = (info["id"] as? UUID) ?? UUID()
        team.recordMetadata = info["recordMetadata"] as? Data
        team.name = info["name"] as? String
        team.points = (info["points"] as? Int32) ?? 0
        team.teamDescription = info["teamDescription"] as? String

        if let imageData = info["photo"] as? Data {
            team.photo = imageData
        }

        return team
    }

    static func add(_ user: User, to team: Team) {
        team.addToMembers(user)
        TeamManager.updateAmountOfPoints(for: team)
    }

    static func remove(_ user: User, from team: Team) {
        team.removeFromMembers(user)
//        guard TeamManager.checkValid(team) else {
//            TeamManager.remove(team)
//            return
//        }
        TeamManager.updateAmountOfPoints(for: team)

    }

    static func update(recordMetadata: Data, of team: Team) {
        team.recordMetadata = recordMetadata
        CoreDataStore.saveContext()
    }

    static func remove(_ team: Team) {
        CoreDataStore.context.delete(team)
    }

    static func validateAllTeams() {
        for team in TeamManager.allTeams() {
            if !TeamManager.checkValid(team) {
                TeamManager.remove(team)
            }
        }
    }

    static func checkValid(_ team: Team) -> Bool {
        guard let members = team.members else { return false }
        return members.count > 0
    }

    @discardableResult
    static func updateAmountOfPoints(for team: Team) -> Int {
        guard let set = team.members, let members = Array(set) as? [User] else { return 0 }
        let teamPoints = members.reduce(0, { x, y in
            x + Int(y.points)
        })
        team.points = Int32(teamPoints)
        CoreDataStore.saveContext()
        return teamPoints
    }

    static func allTeams() -> [Team] {
        let request = NSFetchRequest<Team>(entityName: "Team")
        let teams = CoreDataStore.fetch(request)
        return teams
    }
}
