//
//  Calendar+GetUpdateTimes.swift
//  FinalChallenge
//
//  Created by Martônio Júnior on 02/09/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import Foundation

extension Calendar {
    // Update Time: Sunday 6AM
    func getLastUpdateTime(from: Date) -> Date? {
        guard let lastWeekDate = date(byAdding: .weekOfYear, value: -1, to: from),
            let lastUpdateTime = getNextUpdateTime(from: lastWeekDate) else {
                return nil
        }
        return lastUpdateTime
    }
    
    func getNextUpdateTime(from: Date) -> Date? {
        guard let nextSunday = date(bySetting: .weekday, value: 1, of: from),
            let nextUpdateTime = date(bySetting: .hour, value: 3, of: nextSunday) else {
                return nil
        }
        return nextUpdateTime
    }
}

