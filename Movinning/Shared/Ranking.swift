//
//  Ranking.swift
//  Movinning
//
//  Created by Martônio Júnior on 13/11/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import Foundation

enum Ranking: String {
    case fan
    case defender
    case expert
    case maniac
    case champion
    case lunatic

    func tierName() -> String {
        return NSLocalizedString(self.rawValue, comment: "")
    }

    func rankingValue() -> Int {
        switch self {
        case .fan:
            return 1
        case .defender:
            return 5
        case .expert:
            return 10
        case .maniac:
            return 20
        case .champion:
            return 50
        case .lunatic:
            return 100
        }
    }
}
