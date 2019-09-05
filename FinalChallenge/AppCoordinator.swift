//
//  AppCoordinator.swift
//  FinalChallenge
//
//  Created by Matheus Oliveira Costa on 02/09/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit

final class AppCoordinator: NSObject, Coordinator {
    var childCoordinators: [Coordinator]?

    var rootViewController: UIViewController {
        return tabBarController
    }

    var tabBarController: UITabBarController

    init(tabBarController: UITabBarController) {
        self.tabBarController = tabBarController
        self.childCoordinators = [
            TeamTabCoordinator(navigationController: UINavigationController())
        ]

        super.init()

        self.tabBarController.viewControllers = self.childCoordinators?.map { $0.rootViewController }
        self.tabBarController.tabBar.isTranslucent = false
        self.tabBarController.delegate = self
    }

    func start() {
        let firstCoordinator = childCoordinators?.first
        firstCoordinator?.start()
    }
}

// MARK: - UITabBarControllerDelegate
extension AppCoordinator: UITabBarControllerDelegate {

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let coordinator = self.childCoordinators?.first(where: { $0.rootViewController == viewController })
        coordinator?.start()
    }

}
