//
//  MovinningUserManagerTests.swift
//  MovinningTests
//
//  Created by Martônio Júnior on 19/10/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

@testable import Movinning
import XCTest

class MovinningUserManagerTests: XCTestCase {
    var testUser: User!

    override func setUp() {
        testUser = User(context: CoreDataStore.context)
        UserDefaults.standard.goalUpdateTime = nil
    }

    override func tearDown() {
        CoreDataStore.context.delete(testUser)
        UserDefaults.standard.goalUpdateTime = nil
    }

    func test_usermanager_changeGoalsForUserAtDate() {
        let now = Date()

        UserManager.changeGoals(for: testUser, at: now)
        guard let currentGoals = testUser.currentGoals else {
            XCTAssert(false)
            return
        }

        XCTAssert(UserDefaults.standard.goalUpdateTime == now)
        XCTAssert(currentGoals.value.count == 3)
        XCTAssert(currentGoals.value.contains(0))
        XCTAssert(currentGoals.value.contains(1))
        XCTAssert(currentGoals.value.contains(2))
    }

    func test_usermanager_createUserWithData() {

    }

    func test_usermanager_updateDataOfUser() {

    }

    func test_usermanager_logoutUser() {
        UserManager.logout(user: testUser)
    }

    func test_usermanager_addPointsToUser() {
        UserManager.add(points: 500, to: testUser)
        XCTAssert(testUser.points == 500)
    }

    func test_usermanager_getLoggedUser() {
        let user = UserManager.getLoggedUser()
        XCTAssert(user != nil)
    }
}
