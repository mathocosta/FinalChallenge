//
//  AchievementsView.swift
//  Movinning
//
//  Created by Thalia Freitas on 20/11/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit

class AchievementsView: UIView {

    lazy var achievementsList: AchievementListView = {
        let achievements = AchievementListView()
        return achievements
    }()

    let user: User

    init(frame: CGRect = .zero, user: User) {
        self.user = user
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension AchievementsView: CodeView {
    func buildViewHierarchy() {
        addSubview(achievementsList)
    }

    func setupConstraints() {

    }

    func setupAdditionalConfiguration() {

    }
}
