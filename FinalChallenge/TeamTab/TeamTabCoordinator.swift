//
//  TeamTabCoordinator.swift
//  FinalChallenge
//
//  Created by Matheus Oliveira Costa on 04/09/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit

final class TeamTabCoordinator: Coordinator {
    var childCoordinators: [Coordinator]?

    var rootViewController: UIViewController {
        return navigationController
    }

    private let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.tabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 2)
    }

    func start() {
        guard navigationController.topViewController == nil else { return }

        let viewController = TeamEntranceViewController()
        viewController.coordinator = self

        navigationController.pushViewController(viewController, animated: true)
    }
}
