//
//  AchievementsViewController.swift
//  Movinning
//
//  Created by Thalia Freitas on 20/11/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import Foundation
import UIKit

class AchievementsViewController: UIViewController {

    private let achievementsList: AchievementListView
    private let user: User

    weak var coordinator: AchievementsTabCoordinator?

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(user: User) {
        self.user = user
        self.achievementsList = AchievementListView(frame: .zero, direction: .vertical)
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = achievementsList
        SessionManager.current.updateRegister(of: user).done(on: .main) { _ in
            self.coordinator?.showAchievementsViewController(for: self.user)
        }.catch(on: .main) { (_) in
            self.presentAlert(with: NSLocalizedString("An Error has occured", comment: ""),
                              message: NSLocalizedString("iCloud Auth Error", comment: ""),
                              completion: {})
        }
        print(UIScreen.main.bounds)

    }

}
