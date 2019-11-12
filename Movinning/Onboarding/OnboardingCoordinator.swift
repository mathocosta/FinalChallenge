//
//  OnboardingCoordinator.swift
//  FinalChallenge
//
//  Created by Matheus Oliveira Costa on 14/09/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit

class OnboardingCoordinator: Coordinator {
    var childCoordinators: [Coordinator]?

    var rootViewController: UIViewController {
        return navigationController
    }

    let navigationController: UINavigationController
    var onboardViewController: OnboardingViewController?

    var didLoginEnded: (() -> Void)?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.navigationBar.isHidden = true
//        self.childCoordinators = [
//            UserPreferencesCoordinator(navigationController: navigationController)
//        ]
    }

    func start() {
        let userDefaults = UserDefaults.standard
        if !userDefaults.isHealthKitAuthorized {
            showMessageView(for: 0)
        } else if !userDefaults.hasChosenUserPreferences {
            showUserPreferences()
        } else if !userDefaults.isCloudKitAuthorized {
            showMessageView(for: 1)
        } else if !userDefaults.isRegistrationComplete {
            showMessageView(for: 2)
        }
    }

    func showNextScreen() {
        if let onboardViewController = onboardViewController {
            let currentPage = onboardViewController.onboardingView.currentPage
            let contentType = onboardViewController.content[currentPage]
            if contentType == .healthKitAuthorization {
                showMessageView(for: 1)
            } else if contentType == .cloudKitAuthorization {
                showMessageView(for: 2)
            } else if contentType == .addMoreInformation {
                navigationController.dismiss(animated: true, completion: { [weak self] in
                    guard let didLoginEnded = self?.didLoginEnded else { return }
                    didLoginEnded()
                })
            }
        } else {
            showMessageView(for: 0)
        }
    }

    func showUserPreferences() {        
        let viewController = UserPreferencesViewController()
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: true)
    }

    func popUserPreferences() {
        navigationController.popViewController(animated: true)
        showNextScreen()
    }

    func showMessageView(for contentTypeIndex: Int) {
        if onboardViewController == nil {
            onboardViewController = OnboardingViewController()
            onboardViewController?.coordinator = self
            navigationController.pushViewController(onboardViewController ?? OnboardingViewController(), animated: true)
            onboardViewController?.beginningPage = contentTypeIndex
        } else {
            onboardViewController?.moveTo(page: contentTypeIndex)
        }
    }
}
