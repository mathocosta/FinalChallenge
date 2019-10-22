//
//  MovinningGoalPileTests.swift
//  MovinningTests
//
//  Created by Martônio Júnior on 18/10/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

@testable import Movinning
import XCTest

class MovinningGoalPileTests: XCTestCase {
    var gp: GoalPile!

    override func setUp() {
        gp = GoalPile(value: [0,2,5])
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_goalpile_empty() {
        XCTAssert(!gp.isEmpty)
        gp = gp.remove(0)
        gp = gp.remove(2)
        gp = gp.remove(5)
        XCTAssert(gp.isEmpty)
    }

    func test_goalpile_add() {
        gp = gp.add(8)
        XCTAssert(gp.value.count == 4)
        XCTAssert(gp.value.contains(8))
    }

    func test_goalpile_remove() {
        gp = gp.remove(5)
        XCTAssert(gp.value.count == 2)
        XCTAssert(!gp.value.contains(5))
    }

    func test_goalpile_mark() {
        gp = gp.mark(2)
        XCTAssert(gp.markedValues.count == 1)
        XCTAssert(gp.markedValues.contains(2))
    }

    func test_goalpile_unmark() {
        gp = gp.mark(2)
        gp = gp.mark(5)
        gp = gp.unmark(2)
        XCTAssert(gp.markedValues.count == 1)
        XCTAssert(!gp.markedValues.contains(2))
    }

    func test_goalpile_unmarkedGoals() {
        gp = gp.mark(0)
        XCTAssert(gp.unmarkedGoals().count == 2)
        XCTAssert(!gp.unmarkedGoals().contains(0))
    }
}
