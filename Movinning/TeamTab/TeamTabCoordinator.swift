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
        self.navigationController.tabBarItem = UITabBarItem(
            title: "Team",
            image: UIImage(named: "group-unselected"),
            selectedImage: UIImage(named: "group-selected")
        )
        self.navigationController.navigationBar.tintColor = .textColor
        self.navigationController.navigationBar.isTranslucent = false
        self.navigationController.navigationBar.barTintColor = .backgroundColor
        self.navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController.navigationBar.shadowImage = UIImage()
        self.navigationController.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.sectionTitle
        ]
    }

    func start() {
        guard navigationController.topViewController == nil,
            let loggedUser = UserManager.getLoggedUser() else { return }

        if let team = loggedUser.team {
            showTeamProgress(for: team, user: loggedUser)
        } else {
            showTeamList()
        }
    }

    func showTeamProgress(for team: Team, user: User) { //TODO Quando houver metas em time, mudar para TEAM
        let view = UsersCloud(frame: .zero,
                              team: team,
                              action: showDetails)
        view.translatesAutoresizingMaskIntoConstraints = false
        let viewController = ProgressViewController(user: user,
                                                    centerView: view,
                                                    amount: 0,
                                                    hasRanking: true,
                                                    rankingAction: showTeamRanking)
        viewController.coordinator = self
        
        navigationController.setViewControllers([viewController], animated: true)
    }
    
    func showTeamList() {
        let viewController = TeamListViewController()
        viewController.coordinator = self

        if navigationController.visibleViewController is TeamDetailsViewController {
            navigationController.setViewControllers([viewController], animated: true)
        } else {
            navigationController.pushViewController(viewController, animated: true)
        }
    }

    func showEntrance(of team: Team) {
        let viewController = TeamEntranceViewController(team: team)
        viewController.coordinator = self

        navigationController.pushViewController(viewController, animated: true)
    }

    func showCreateTeam() {
        let viewController = CreateTeamViewController()
        viewController.coordinator = self

        navigationController.pushViewController(viewController, animated: true)
    }

    func showTeamMembers(of team: Team) {
        let viewController = TeamMembersViewController(of: team)
        viewController.coordinator = self

        navigationController.pushViewController(viewController, animated: true)
    }

    func showDetails(of team: Team) {
        let viewController = TeamDetailsViewController(team: team)
        viewController.coordinator = self

        // É preciso resetar as view controllers quando fizer a criação ou entrar num novo time
        let visibleViewController = navigationController.visibleViewController
        if (visibleViewController is TeamEntranceViewController) ||
            (visibleViewController is CreateTeamViewController) {
            navigationController.setViewControllers([viewController], animated: true)
        } else {
            navigationController.pushViewController(viewController, animated: true)
        }
    }

    func showTeamRanking() {
        let viewController = TeamRankingViewController()
        viewController.coordinator = self

        navigationController.pushViewController(viewController, animated: true)
    }
}
