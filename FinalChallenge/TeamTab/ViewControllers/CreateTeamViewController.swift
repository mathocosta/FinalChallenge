//
//  CreateTeamViewController.swift
//  FinalChallenge
//
//  Created by Matheus Oliveira Costa on 13/09/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit

class CreateTeamViewController: UIViewController {

    private let createTeamView: CreateTeamView

    weak var coordinator: TeamTabCoordinator?

    init() {
        self.createTeamView = CreateTeamView()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = createTeamView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let createBarButton = UIBarButtonItem(
            barButtonSystemItem: .save, target: self, action: #selector(createBarButtonTapped(_:)))
        navigationItem.rightBarButtonItem = createBarButton
    }

    @objc func createBarButtonTapped(_ sender: UIBarButtonItem) {
//        if let nameText = createTeamView.nameInput.inputTextField.text {
//
//        }
//
//        if let descriptionText = createTeamView.descriptionInput.inputTextField.text {
//
//        }
//
//        if let cityText = createTeamView.cityInput.inputTextField.text {
//
//        }
//
//        if let neighborhoodText = createTeamView.neighborhoodInput.inputTextField.text {
//
//        }

        guard let nameText = createTeamView.nameInput.inputTextField.text,
            let loggedUser = UserManager.getLoggedUser() else { return }

        let newTeam = TeamManager.newTeam(named: nameText, createdBy: loggedUser)
        CoreDataManager.saveContext()
        coordinator?.showDetails(of: newTeam)
    }

}
