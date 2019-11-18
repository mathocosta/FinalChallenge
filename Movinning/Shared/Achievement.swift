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
        self.achievementType = Sport(rawValue: achievementInfo["sport"] as? String ?? "") ?? .walking
        self.image = UIImage(named: achievementInfo["image"] as? String ?? "") ?? UIImage()
    }
    
    convenience init(id: Int) {
        let achievementInfo = AchievementManager.getAchievementInfo(withID: id)
        self.init(id: id, achievementInfo: achievementInfo)
    }
    
    func getTitle() {
        
    }
    
    func getDescription() {
        
    }
}
