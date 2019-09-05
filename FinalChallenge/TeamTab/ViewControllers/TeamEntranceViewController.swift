//
//  TeamEntranceViewController.swift
//  FinalChallenge
//
//  Created by Matheus Oliveira Costa on 04/09/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit

class TeamEntranceViewController: UIViewController {

    weak var coordinator: TeamTabCoordinator?

    override func loadView() {
        view = TeamEntranceView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
