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
        self.navigationController.tabBarItem = UITabBarItem(tabBarSystemItem: .featured, tag: 2)
    }
    
    func start() {
        guard navigationController.topViewController == nil else { return }
        
        let viewController = ProfileViewController()
        viewController.coordinator = self
        
        navigationController.pushViewController(viewController, animated: true)
    }
}
