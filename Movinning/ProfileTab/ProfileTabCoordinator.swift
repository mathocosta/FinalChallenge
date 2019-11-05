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
        self.navigationController.navigationBar.tintColor = .textColor
        self.navigationController.navigationBar.barTintColor = UIColor.backgroundColor
        self.navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController.navigationBar.shadowImage = UIImage()
        self.navigationController.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.sectionTitle
        ]
        self.navigationController.tabBarItem = UITabBarItem(
            title: "Profile",
            image: UIImage(named: "profile-unselected"),
            selectedImage: UIImage(named: "profile-selected")
        )
        self.childCoordinators = [
            UserPreferencesCoordinator(navigationController: navigationController)
        ]
    }

    func start() {
        guard navigationController.topViewController == nil,
            let loggedUser = UserManager.getLoggedUser() else { return }

        if !UserDefaults.standard.isRegistrationComplete
            && UserDefaults.standard.isCloudKitAuthorized {
            showProfileEditViewController(for: loggedUser)
        } else {
            showProfileViewController(for: loggedUser)
        }
    }

    func showRanking() {

    }

    func showProfileViewController(for user: User) {
        let view = ProfileDetailsView(frame: CGRect(x: 0, y: 0, width: 119, height: 130),
                                      name: user.firstName ?? "",
                                      level: Int(user.points),
                                      user: user,
                                      action: showProfileEditViewController(for:))
        view.translatesAutoresizingMaskIntoConstraints = false

        if let imageData = user.photo, let profileImage = UIImage(data: imageData) {
            view.imageView.image = profileImage
        }

        let viewController = ProgressViewController(user: user,
                                                    centerView: view,
                                                    amount: 3,
                                                    hasRanking: false,
                                                    rankingAction: showRanking)
        viewController.coordinator = self

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

    func showUserPreferences() {
        if let coordinator = self.childCoordinators?.first as? UserPreferencesCoordinator {
            coordinator.start()
        }
    }

}
