//
//  ProfileTabCoordinator.swift
//  FinalChallenge
//
//  Created by Paulo José on 06/09/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit

final class ProfileTabCoordinator: Coordinator {
    var childCoordinators: [Coordinator]?

    var rootViewController: UIViewController {
        return navigationController
    }

    private let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.navigationBar.isTranslucent = false
        self.navigationController.navigationBar.barTintColor = UIColor.backgroundColor
        self.navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController.navigationBar.shadowImage = UIImage()
        self.navigationController.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.sectionLightStyle
        ]
        self.navigationController.tabBarItem = UITabBarItem(
            title: "Profile",
            image: UIImage(named: "profile-unselected"),
            selectedImage: UIImage(named: "profile-selected")
        )
    }

    func start() {
        guard navigationController.topViewController == nil,
            let loggedUser = UserManager.getLoggedUser() else { return }

        if !UserDefaults.standard.isRegistrationComplete {
            showProfileEditViewController(for: loggedUser)
        } else {
            showProfileViewController(for: loggedUser)
        }
    }

    func showProfileViewController(for user: User) {
        let viewController = ProfileViewController(user: user)
        viewController.coordinator = self

        // Essa checagem é para atualizar a view do perfil após alguma mudança na view de editar
        if navigationController.topViewController is ProfileEditViewController {
            navigationController.popViewController(animated: true)
            navigationController.setViewControllers([viewController], animated: false)
        } else {
            navigationController.pushViewController(viewController, animated: true)
        }
    }

    func showProfileEditViewController(for user: User) {
        let viewController = ProfileEditViewController(user: user)
        viewController.coordinator = self

        navigationController.pushViewController(viewController, animated: true)
    }

}
