//
//  Coordinator.swift
//  FinalChallenge
//
//  Created by Matheus Oliveira Costa on 02/09/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator]? { get set }
    var rootViewController: UIViewController { get }

    func start()
}
