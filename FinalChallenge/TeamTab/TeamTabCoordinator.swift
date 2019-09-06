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
        self.navigationController.navigationBar.isTranslucent = false
    }

    func start() {
        guard navigationController.topViewController == nil else { return }

        let loggedUser = UserManager.getLoggedUser()

        if let team = loggedUser.team {
            showDetails(of: team)
        } else {
            showTeamList()
        }
    }

    func showTeamList() {
        let viewController = TeamListViewController()
        viewController.coordinator = self

        navigationController.pushViewController(viewController, animated: true)
    }

    func showEntrance(of team: Team) {
        let viewController = TeamEntranceViewController(team: team)
        viewController.coordinator = self

        navigationController.pushViewController(viewController, animated: true)
    }

    func showDetails(of team: Team) {
        // É necessário dar o pop para não deixar a view controller de entrada no grupo
        // na pilha de views controllers da navigation controller.
        if navigationController.visibleViewController is TeamEntranceViewController {
            navigationController.popViewController(animated: false)
        }

        let viewController = TeamDetailsViewController(team: team)
        navigationController.pushViewController(viewController, animated: true)
    }
}
