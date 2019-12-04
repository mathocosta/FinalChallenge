//
//  MovinningSportTests.swift
//  MovinningTests
//
//  Created by Martônio Júnior on 24/10/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import XCTest
import HealthKit
@testable import Movinning

class MovinningSportTests: XCTestCase {

    override func setUp() {

    }

    override func tearDown() {

    }

    func test_sport_servicesForSport() {
        XCTAssert(Sport.walking.services().contains(.stepCount))
        XCTAssert(Sport.running.services().contains(.distanceWalkingRunning))
        XCTAssert(Sport.soccer.services().contains(.soccer))
        XCTAssert(Sport.cycling.services().contains(.cycling))
        XCTAssert(Sport.training.services().contains(.functionalTraining))
        XCTAssert(Sport.training.services().contains(.traditionalTraining))
        XCTAssert(Sport.cricket.services().contains(.cricket))
        XCTAssert(Sport.hockey.services().contains(.hockey))
        XCTAssert(Sport.tennis.services().contains(.tennis))
        XCTAssert(Sport.volleyball.services().contains(.volleyball))
        XCTAssert(Sport.tableTennis.services().contains(.tableTennis))
        XCTAssert(Sport.basketball.services().contains(.basketball))
        XCTAssert(Sport.baseball.services().contains(.baseball))
        XCTAssert(Sport.rugby.services().contains(.rugby))
        XCTAssert(Sport.golf.services().contains(.golf))
        XCTAssert(Sport.swimming.services().contains(.swimming))

        XCTAssert(Sport.walking.services().count == 1)
        XCTAssert(Sport.running.services().count == 1)
        XCTAssert(Sport.soccer.services().count == 1)
        XCTAssert(Sport.cycling.services().count == 1)
        XCTAssert(Sport.training.services().count == 2)
        XCTAssert(Sport.cricket.services().count == 1)
        XCTAssert(Sport.hockey.services().count == 1)
        XCTAssert(Sport.tennis.services().count == 1)
        XCTAssert(Sport.volleyball.services().count == 1)
        XCTAssert(Sport.tableTennis.services().count == 1)
        XCTAssert(Sport.basketball.services().count == 1)
        XCTAssert(Sport.baseball.services().count == 1)
        XCTAssert(Sport.rugby.services().count == 1)
        XCTAssert(Sport.golf.services().count == 1)
        XCTAssert(Sport.swimming.services().count == 1)
    }

    func test_sport_permissionsForSports() {
        let permissionsA = Sport.permissions(for: [.hockey, .tableTennis, .baseball, .golf, .soccer])
        XCTAssert(permissionsA.count == 1)
        if let type = HKObjectType.quantityType(forIdentifier: .appleExerciseTime) {
            XCTAssert(permissionsA.contains(type))
        }

        let permissionsB = Sport.permissions(for: [.walking, .running, .swimming])
        XCTAssert(permissionsB.count == 3)
        if let typeA = HKObjectType.quantityType(forIdentifier: .swimmingStrokeCount),
            let typeB = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning),
            let typeC = HKObjectType.quantityType(forIdentifier: .stepCount) {
            XCTAssert(permissionsB.contains(typeA))
            XCTAssert(permissionsB.contains(typeB))
            XCTAssert(permissionsB.contains(typeC))
        }
    }

    func test_sport_localizedName() {
        XCTAssert(Sport.walking.localizedName == NSLocalizedString("walking", comment: ""))
        XCTAssert(Sport.running.localizedName == NSLocalizedString("running", comment: ""))
        XCTAssert(Sport.cycling.localizedName == NSLocalizedString("cycling", comment: ""))
        XCTAssert(Sport.rugby.localizedName == NSLocalizedString("rugby", comment: ""))
    }

    func test_sport_allTypes() {
        XCTAssert(Sport.allTypes == Set(Sport.allCases))
    }
}
