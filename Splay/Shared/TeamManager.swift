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
        let team = Team(context: CoreStataStore.context)
        team.id = UUID()
        team.name = name
        team.points = 0
        TeamManager.add(user, to: team)
        return team
    }

    static func createTeam(with info: [String: Any?]) -> Team {
        let team = Team(context: CoreStataStore.context)

        if let uuidString = info["id"] as? String {
            team.id = UUID(uuidString: uuidString)
        } else {
            team.id = UUID()
        }

        team.recordMetadata = info["recordMetadata"] as? Data
        team.name = info["name"] as? String
        team.points = (info["points"] as? Int32) ?? 0
        team.teamDescription = info["teamDescription"] as? String

        if let imageData = info["photo"] as? Data {
            team.photo = imageData
        }

        return team
    }

    static func update(team: Team, with info: [String: Any?]) {
        if let updatedName = info["name"] as? String {
            team.name = updatedName
        }

        if let updatedPoints = info["points"] as? Int32 {
            team.points = updatedPoints
        }

        if let updatedImage = info["photo"] as? Data {
            team.photo = updatedImage
        }

        if let updatedTeamDescription = info["teamDescription"] as? String {
            team.teamDescription = updatedTeamDescription
        }

        if let updatedRecordMetadata = info["recordMetadata"] as? Data {
            team.recordMetadata = updatedRecordMetadata
        }
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
        CoreStataStore.saveContext()
    }

    static func remove(_ team: Team) {
        CoreStataStore.context.delete(team)
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
        CoreStataStore.saveContext()
        return teamPoints
    }

    static func allTeams() -> [Team] {
        let request = NSFetchRequest<Team>(entityName: "Team")
        let teams = CoreStataStore.fetch(request)
        return teams
    }
}
