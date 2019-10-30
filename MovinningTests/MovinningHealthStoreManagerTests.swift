//
//  MovinningHealthStoreManagerTests.swift
//  MovinningTests
//
//  Created by Martônio Júnior on 20/10/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

@testable import Movinning
import XCTest
import HealthKit

class MovinningHealthStoreManagerTests: XCTestCase {
    var manager: HealthStoreManager!
    var testService: HealthStoreService!

    override func setUp() {
        manager = HealthStoreManager()
        testService = .stepCount
    }

    override func tearDown() {}

    func test_healthstoremanager_quantitySumToday() {
        manager.quantitySumToday(of: testService) { (results) in
            switch results {
            case .success(let statistics):
                XCTAssert(statistics.sumQuantity() == HKQuantity(unit: .count(), doubleValue: 0))
            case .failure(let error):
                XCTAssert(error.localizedDescription != "")
            }
        }
    }

    func test_healthstoremanager_quantitySumSinceLastHour() {
        manager.quantitySumSinceLastHour(of: testService) { (results) in
            switch results {
            case .success(let statistics):
                XCTAssert(statistics.sumQuantity() == HKQuantity(unit: .count(), doubleValue: 0))
            case .failure(let error):
                XCTAssert(error.localizedDescription != "")
            }
        }
    }

    func test_healthstoremanager_samples() {
        manager.samples(of: testService) { (results) in
            switch results {
            case .success(let samples):
                XCTAssert(samples.count == 0)
            case .failure(let error):
                XCTAssert(error.localizedDescription != "")
            }
        }
    }
}
