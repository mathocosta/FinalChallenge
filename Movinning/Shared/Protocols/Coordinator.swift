//
//  Coordinator.swift
//  FinalChallenge
//
//  Created by Matheus Oliveira Costa on 02/09/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit

protocol Coordinator: class {
    var childCoordinators: [Coordinator]? { get set }
    var rootViewController: UIViewController { get }

    func start()
}

extension Coordinator {
    func showLoadingViewController() {
        guard let navController = rootViewController as? UINavigationController else { return }
        let vc = LoadingViewController()
        vc.modalPresentationStyle = .overFullScreen
        navController.present(vc, animated: false, completion: nil)
    }

    func dismissLoadingViewController() {
        guard let navController = rootViewController as? UINavigationController else { return }

        navController.topViewController?.dismiss(animated: true, completion: nil)
    }
}
