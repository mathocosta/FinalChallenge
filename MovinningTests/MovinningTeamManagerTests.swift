//
//  MovinningTeamManagerTests.swift
//  MovinningTests
//
//  Created by Martônio Júnior on 19/10/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

@testable import Movinning
import XCTest

class MovinningTeamManagerTests: XCTestCase {
    var testUserA, testUserB, testUserC: User!
    var testTeam: Team!

    override func setUp() {
        testUserA = User(context: CoreDataStore.context)
        testUserB = User(context: CoreDataStore.context)
        testUserC = User(context: CoreDataStore.context)
        testTeam = Team(context: CoreDataStore.context)
        testTeam.members = [testUserA!, testUserB!, testUserC!]
    }

    override func tearDown() {
        for team in TeamManager.allTeams() {
            CoreDataStore.context.delete(team)
        }
        CoreDataStore.context.delete(testUserA)
        CoreDataStore.context.delete(testUserB)
        CoreDataStore.context.delete(testUserC)
    }

    func test_teammanager_newTeamNamedCreatedByUser() {
        let team = TeamManager.newTeam(named: "Time", createdBy: testUserA)
        guard let members = team.members,
            let testUserA = testUserA else {
            XCTAssert(false)
            return
        }
        XCTAssert(members.count == 1)
        XCTAssert(members.contains(testUserA))
        XCTAssert(team.name == "Time")
        XCTAssert(team.points == 0)
    }

    func test_teammanager_createTeamWithData() {
        let team = TeamManager.createTeam(with: [
            "name": "Time",
            "teamDescription": "É um time",
            "city": "Fortaleza",
            "neighborhood": "Benfica"
        ])

        XCTAssert(team.name == "Time")
        XCTAssert(team.teamDescription == "É um time")
        XCTAssert(team.city == "Fortaleza")
        XCTAssert(team.neighborhood == "Benfica")
        XCTAssert(team.members?.count == 0)
    }

    func test_teammanager_updateTeamWithData() {
        XCTAssert(testTeam.name == nil)
        XCTAssert(testTeam.teamDescription == nil)
        XCTAssert(testTeam.city == nil)
        XCTAssert(testTeam.neighborhood == nil)

        TeamManager.update(team: testTeam, with: [
            "name": "Time",
            "teamDescription": "É um time",
            "city": "Fortaleza",
            "neighborhood": "Benfica"
        ])

        guard let members = testTeam.members,
            let testUserA = testUserA,
            let testUserB = testUserB,
            let testUserC = testUserC else {
            XCTAssert(false)
            return
        }

        XCTAssert(testTeam.name == "Time")
        XCTAssert(testTeam.teamDescription == "É um time")
        XCTAssert(testTeam.city == "Fortaleza")
        XCTAssert(testTeam.neighborhood == "Benfica")
        XCTAssert(members.count == 3)
        XCTAssert(members.contains(testUserA))
        XCTAssert(members.contains(testUserB))
        XCTAssert(members.contains(testUserC))
    }

    func test_teammanager_addUserToTeam() {
        let testUserD = User(context: CoreDataStore.context)

        TeamManager.add(testUserD, to: testTeam)
        guard let members = testTeam.members,
            let testUserA = testUserA,
            let testUserB = testUserB,
            let testUserC = testUserC else {
            XCTAssert(false)
            return
        }
        XCTAssert(members.count == 4)
        XCTAssert(members.contains(testUserA))
        XCTAssert(members.contains(testUserB))
        XCTAssert(members.contains(testUserC))
        XCTAssert(members.contains(testUserD))

        CoreDataStore.context.delete(testUserD)
    }

    func test_teammanager_validateAllTeams() {
        let team = Team(context: CoreDataStore.context)
        TeamManager.validateAllTeams()
        let allTeams = TeamManager.allTeams()
        XCTAssert(allTeams.count == 1)
        XCTAssert(!allTeams.contains(team))
    }

    func test_teammanager_updateAmountOfPointsForTeam() {
        testUserA.points = 400
        testUserB.points = 600
        testUserC.points = 200
        XCTAssert(testTeam.points == 0)
        TeamManager.updateAmountOfPoints(for: testTeam)
        XCTAssert(testTeam.points == 1200)
    }

    func test_teammanager_removeTeam() {
        TeamManager.remove(testTeam)
        XCTAssert(TeamManager.allTeams().count == 0)
    }

    func test_teammanager_removeUserOfTeam() {
        TeamManager.remove(testUserB, from: testTeam)
        guard let members = testTeam.members,
            let testUserA = testUserA,
            let testUserB = testUserB,
            let testUserC = testUserC else {
            XCTAssert(false)
            return
        }
        XCTAssert(members.count == 2)
        XCTAssert(members.contains(testUserA))
        XCTAssert(!members.contains(testUserB))
        XCTAssert(members.contains(testUserC))
    }

    func test_teammanager_checkValidTeam() {
        let team = Team(context: CoreDataStore.context)
        XCTAssert(!TeamManager.checkValid(team))
    }

    func test_teammanager_allTeams() {
        let teams = TeamManager.allTeams()
        XCTAssert(teams.count == 1)
        XCTAssert(teams.contains(testTeam))
    }
}
