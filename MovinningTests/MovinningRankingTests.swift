//
//  MovinningRankingTests.swift
//  MovinningTests
//
//  Created by Martônio Júnior on 25/11/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import XCTest
@testable import Movinning

class MovinningRankingTests: XCTestCase {
    var allRankings: [Ranking] = []
    override func setUp() {
        allRankings = [.fan, .defender, .expert, .maniac, .champion, .lunatic]
    }

    override func tearDown() {
        allRankings = []
    }

    func test_ranking_tierName() {
        for ranking in allRankings {
            XCTAssert(ranking.tierName() == NSLocalizedString(ranking.rawValue, comment: ""))
        }
    }

    func test_ranking_rankingValue() {
        let values = [1, 5, 10, 20, 50, 100]
        for index in 0..<allRankings.count {
            let ranking = allRankings[index]
            XCTAssert(ranking.rankingValue() == values[index])
        }
    }
}
