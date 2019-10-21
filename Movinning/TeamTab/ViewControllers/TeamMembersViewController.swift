//
//  TeamMembersViewController.swift
//  Movinning
//
//  Created by Paulo José on 21/10/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit

class TeamMembersViewController: UIViewController {

    private let team: Team

    weak var coordinator: TeamTabCoordinator?
    
    init(of team: Team) {
        self.team = team
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = TeamMembersView(frame: .zero, team: team)
    }

}
