//
//  Achievement.swift
//  Movinning
//
//  Created by Martônio Júnior on 13/11/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit

class Achievement {
    var id: Int
    var ranking: Ranking
    var achievementType: Sport
    var image: UIImage

    init(id: Int, achievementInfo: [String: Any]) {
        self.id = id
        self.ranking = Ranking(rawValue: achievementInfo["ranking"] as? String ?? "") ?? .fan
        self.achievementType = Sport(rawValue: achievementInfo["type"] as? String ?? "") ?? .walking
        self.image = UIImage(named: "avatar-placeholder") ?? UIImage()
        // UIImage(named: achievementInfo["image"] as? String ?? "") ?? UIImage()
    }

    convenience init(id: Int) {
        let achievementInfo = AchievementManager.getAchievementInfo(withID: id)
        self.init(id: id, achievementInfo: achievementInfo)
    }

    func getTag() -> String {
        var type = self.achievementType.rawValue
        var ranking = self.ranking.rawValue
        type.capitalizeFirstLetter()
        ranking.capitalizeFirstLetter()
        return type+" "+ranking
    }

    func getTitle() -> String {
        let tag = getTag()
        return NSLocalizedString(tag+" Title", comment: "")
    }

    func getDescription() -> String {
        let tag = getTag()
        return NSLocalizedString(tag+" Description", comment: "")
    }

    func requiredAmount() -> Int {
        return ranking.rankingValue() * achievementType.achievementValue()
    }
}
