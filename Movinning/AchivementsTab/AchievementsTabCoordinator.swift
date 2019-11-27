//
//  AchievementsTabCoordinator.swift
//  Movinning
//
//  Created by Thalia Freitas on 20/11/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit

final class AchievementsTabCoordinator: Coordinator {
    var childCoordinators: [Coordinator]?

    var rootViewController: UIViewController {
        return navigationController
    }

    private let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.navigationBar.isTranslucent = false
        self.navigationController.navigationBar.tintColor = .textColor
        self.navigationController.navigationBar.barTintColor = UIColor.backgroundColor
        self.navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController.navigationBar.shadowImage = UIImage()
        self.navigationController.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.sectionTitle
        ]
        self.navigationController.tabBarItem = UITabBarItem(
            title: "Achievements",
            image: UIImage(named: "achievement-unselected"),
            selectedImage: UIImage(named: "achievement-selected")
        )
    }

    func start() {
        guard navigationController.topViewController == nil,
            let loggedUser = UserManager.getLoggedUser() else { return }
        showAchievementsViewController(for: loggedUser)
    }

    func showAchievementsViewController(for user: User) {
        let view = AchievementListView(frame: CGRect(x: 0, y: 0, width: 375, height: 667))
        view.translatesAutoresizingMaskIntoConstraints = false
        let viewController = AchievementsViewController(user: user)
        navigationController.pushViewController(viewController, animated: true)
    }
}
