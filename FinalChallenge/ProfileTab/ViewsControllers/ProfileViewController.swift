//
//  ProfileViewController.swift
//  FinalChallenge
//
//  Created by Paulo José on 04/09/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    weak var coordinator: ProfileTabCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()

        let profileView = ProfileView()
        profileView.coordinator = coordinator

        self.view = profileView
    }

}
