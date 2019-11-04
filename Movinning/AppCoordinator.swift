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

    var firstLoginCoordinator: FirstLoginCoordinator?

    var rootViewController: UIViewController {
        return tabBarController
    }

    var tabBarController: UITabBarController

    init(tabBarController: UITabBarController) {
        self.tabBarController = tabBarController
        self.childCoordinators = [
            ProfileTabCoordinator(navigationController: UINavigationController()),
            TeamTabCoordinator(navigationController: UINavigationController())
        ]

        super.init()

        self.tabBarController.viewControllers = self.childCoordinators?.map { $0.rootViewController }
        self.tabBarController.tabBar.isTranslucent = false
        self.tabBarController.tabBar.barTintColor = .tabBarColor
        self.tabBarController.tabBar.tintColor = .tabBarItemColor
        self.tabBarController.delegate = self
    }

    func start() {
        guard !UserDefaults.standard.userNeedToLogin else {
            showFirstLoginFlow()
            return
        }
        showMainFlow()
    }

    func showFirstLoginFlow() {
        let navigationController = UINavigationController()
        navigationController.modalPresentationStyle = .fullScreen
        firstLoginCoordinator = FirstLoginCoordinator(navigationController: navigationController)
        firstLoginCoordinator?.start()
        firstLoginCoordinator?.didLoginEnded = { [weak self] in
            self?.showMainFlow()
        }
        tabBarController.present(navigationController, animated: true, completion: nil)
    }

    func showMainFlow() {
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
