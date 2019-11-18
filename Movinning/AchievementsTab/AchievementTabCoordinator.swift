//
//  AchievementTabCoordinator.swift
//  Movinning
//
//  Created by Martônio Júnior on 18/11/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit

final class AchievementTabCoordinator: Coordinator {
    var childCoordinators: [Coordinator]?

    var rootViewController: UIViewController {
        return navigationController
    }

    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.tabBarItem = UITabBarItem(
            title: "Team",
            image: UIImage(named: "group-unselected"),
            selectedImage: UIImage(named: "group-selected")
        )
        self.navigationController.navigationBar.tintColor = .textColor
        self.navigationController.navigationBar.isTranslucent = false
        self.navigationController.navigationBar.barTintColor = .backgroundColor
        self.navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController.navigationBar.shadowImage = UIImage()
        self.navigationController.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.sectionTitle
        ]
    }
    
    func start() {
        guard navigationController.topViewController == nil,
            let loggedUser = UserManager.getLoggedUser() else { return }
        showUserAchievements(for: loggedUser)
    }
    
    func showUserAchievements(for user: User) {
        
    }
}
