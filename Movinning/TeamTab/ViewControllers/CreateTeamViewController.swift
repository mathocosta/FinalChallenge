//
//  CreateTeamViewController.swift
//  FinalChallenge
//
//  Created by Matheus Oliveira Costa on 13/09/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit

class CreateTeamViewController: UIViewController, LoaderView {

    var loadingView: LoadingView = {
        let view = LoadingView()
        return view
    }()

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

        title = NSLocalizedString("Create Team", comment: "")

        let createBarButton = UIBarButtonItem(
            barButtonSystemItem: .save, target: self, action: #selector(createBarButtonTapped(_:)))
        navigationItem.rightBarButtonItem = createBarButton
    }

    @objc func createBarButtonTapped(_ sender: UIBarButtonItem? = nil) {
        guard let nameText = createTeamView.nameInput.inputTextField.text, !nameText.isEmpty else {
            let alert = UIAlertController.okAlert(
                title: NSLocalizedString("Error", comment: ""),
                message: NSLocalizedString("Name Field Missing", comment: "")
            )
            return present(alert, animated: true)
        }

        let descriptionText = createTeamView.descriptionInput.textView.text
        let cityText = createTeamView.cityInput.inputTextField.text
        let neighborhoodText = createTeamView.neighborhoodInput.inputTextField.text

        guard let loggedUser = UserManager.getLoggedUser() else { return }

        let newTeam = TeamManager.createTeam(with: [
            "name": nameText,
            "teamDescription": descriptionText,
            "city": cityText,
            "neighborhood": neighborhoodText
        ])

        startLoader()
        SessionManager.current.create(team: newTeam, with: loggedUser).done(on: .main) { _ in
            self.stopLoader()
            self.coordinator?.showDetails(of: newTeam)
        }.catch(on: .main) { _ in
            self.stopLoader()
            self.presentAlert(with: NSLocalizedString("An Error has occured", comment: ""),
                              message: NSLocalizedString("Try again", comment: "")) {
                                self.createBarButtonTapped()
            }
        }
    }

}
