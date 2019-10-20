//
//  MovinningHealthStoreServiceTests.swift
//  MovinningTests
//
//  Created by Martônio Júnior on 20/10/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

@testable import Movinning
import XCTest
import HealthKit

class MovinningHealthStoreServiceTests: XCTestCase {

    override func setUp() {

    }

    override func tearDown() {

    }

    func test_healthstoreservice_type() {
        let testTypes: [HKObjectType?] = [
            HKObjectType.quantityType(forIdentifier: .pushCount),
            HKObjectType.quantityType(forIdentifier: .stepCount),
            HKObjectType.quantityType(forIdentifier: .distanceWheelchair),
            HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning),
            HKObjectType.quantityType(forIdentifier: .distanceCycling),
            HKObjectType.quantityType(forIdentifier: .swimmingStrokeCount),
            HKObjectType.quantityType(forIdentifier: .appleExerciseTime)
        ]
        for service in HealthStoreService.allCases {
            XCTAssert(testTypes.contains(service.type))
        }
    }

    func test_healthstoreservice_queryPredicate() {
        let soccer = HealthStoreService.soccer
        XCTAssert(soccer.queryPredicate == HKQuery.predicateForWorkouts(with: .soccer))

        let functionalTraining = HealthStoreService.functionalTraining
        XCTAssert(functionalTraining.queryPredicate == HKQuery.predicateForWorkouts(with: .functionalStrengthTraining))

        let traditionalTraining = HealthStoreService.traditionalTraining
        XCTAssert(traditionalTraining.queryPredicate == HKQuery.predicateForWorkouts(with: .traditionalStrengthTraining))

        let cricket = HealthStoreService.cricket
        XCTAssert(cricket.queryPredicate == HKQuery.predicateForWorkouts(with: .cricket))

        let hockey = HealthStoreService.hockey
        XCTAssert(hockey.queryPredicate == HKQuery.predicateForWorkouts(with: .hockey))

        let volleyball = HealthStoreService.volleyball
        XCTAssert(volleyball.queryPredicate == HKQuery.predicateForWorkouts(with: .volleyball))

        let tableTennis = HealthStoreService.tableTennis
        XCTAssert(tableTennis.queryPredicate == HKQuery.predicateForWorkouts(with: .tableTennis))

        let basketball = HealthStoreService.basketball
        XCTAssert(basketball.queryPredicate == HKQuery.predicateForWorkouts(with: .basketball))

        let baseball = HealthStoreService.baseball
        XCTAssert(baseball.queryPredicate == HKQuery.predicateForWorkouts(with: .baseball))
        
        let rugby = HealthStoreService.rugby
        XCTAssert(rugby.queryPredicate == HKQuery.predicateForWorkouts(with: .rugby))

        let golf = HealthStoreService.golf
        XCTAssert(golf.queryPredicate == HKQuery.predicateForWorkouts(with: .golf))

        let swimming = HealthStoreService.swimming
        XCTAssert(swimming.queryPredicate == nil)
    }

    func test_healthstoreservice_allTypes() {
        for service in HealthStoreService.allTypes {

        }
    }

    func test_healthstoreservice_unit() {
        let stepCount = HealthStoreService.stepCount
        XCTAssert(stepCount.unit == HKUnit.count())

        let soccer = HealthStoreService.soccer
        XCTAssert(soccer.unit == HKUnit.minute())

        let cycling = HealthStoreService.cycling
        XCTAssert(cycling.unit == HKUnit.meter())
    }

    func test_healthstoreservice_typeForTag() {
        let service = HealthStoreService.type(forTag: "traditionalTraining")
        XCTAssert(service == .traditionalTraining)
    }
}
