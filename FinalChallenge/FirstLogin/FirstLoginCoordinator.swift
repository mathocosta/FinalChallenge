//
//  FirstLoginCoordinator.swift
//  FinalChallenge
//
//  Created by Matheus Oliveira Costa on 14/09/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit

class FirstLoginCoordinator: Coordinator {
    var childCoordinators: [Coordinator]?

    var rootViewController: UIViewController {
        return navigationController
    }

    let navigationController: UINavigationController

    var didLoginEnded: (() -> Void)?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.navigationBar.isHidden = true
    }

    func start() {
        let userDefaults = UserDefaults.standard
        if !userDefaults.isHealthKitAuthorized {
            showMessageView(for: .healthKitAuthorization)
        } else if !userDefaults.isCloudKitAuthorized {
            showMessageView(for: .cloudKitAuthorization)
        } else if !userDefaults.isRegistrationComplete {
            showMessageView(for: .addMoreInformation)
        }
    }

    func showNextScreen() {
        if let messageViewController = navigationController.topViewController as? MessageViewController {
            let contentType = messageViewController.contentType

            if contentType == .healthKitAuthorization {
                showMessageView(for: .cloudKitAuthorization)
            } else if contentType == .cloudKitAuthorization {
                showMessageView(for: .addMoreInformation)
            } else if contentType == .addMoreInformation {
                navigationController.dismiss(animated: true, completion: { [weak self] in
                    guard let didLoginEnded = self?.didLoginEnded else { return }
                    didLoginEnded()
                })
            }
        }
    }

    func showMessageView(for contentType: MessageViewContent) {
        let viewController = MessageViewController(content: contentType)
        viewController.coordinator = self

        navigationController.pushViewController(viewController, animated: true)
    }

}
