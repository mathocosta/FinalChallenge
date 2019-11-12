//
//  UserPreferencesCoordinator.swift
//  Movinning
//
//  Created by Martônio Júnior on 05/11/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit

final class UserPreferencesCoordinator: Coordinator {
    var rootViewController: UIViewController {
        return navigationController
    }
    var childCoordinators: [Coordinator]?
    var userPreferencesViewController: UserPreferencesViewController?

    private let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.modalPresentationStyle = .fullScreen
    }

    func start() {
        navigationController.navigationBar.isHidden = true
        showUserPreferencesController()
    }

    func redirectToNextScreen() {
        if rootViewController is ProfileEditViewController {
            navigationController.navigationBar.isHidden = false
            self.navigationController.popViewController(animated: true)
        } else if let rootViewController = rootViewController as? OnboardingViewController {
            self.navigationController.popViewController(animated: true)
            rootViewController.coordinator?.showNextScreen()
        }
    }

    func showUserPreferencesController() {
        let viewController = UserPreferencesViewController()
//        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: true)
    }
}
