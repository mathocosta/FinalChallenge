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
        guard let nameText = createTeamView.nameInput.inputTextField.text, !nameText.isEmpty else {
            return presentAlert(with: NSLocalizedString("Name Field Missing", comment: ""))
        }

        let descriptionText = createTeamView.descriptionInput.inputTextField.text

        guard let loggedUser = UserManager.getLoggedUser() else { return }

        let newTeam = TeamManager.createTeam(with: [
            "name": nameText,
            "teamDescription": descriptionText
        ])
        SessionManager.current.create(team: newTeam, with: loggedUser) { (result) in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self.coordinator?.showDetails(of: newTeam)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    func presentAlert(with message: String) {
        let alert = UIAlertController(
            title: NSLocalizedString("Error", comment: ""),
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(
            title: NSLocalizedString("OK", comment: "Default Action"),
            style: .default,
            handler: { _ in
                alert.dismiss(animated: true, completion: nil)
            }
        ))

        present(alert, animated: true, completion: nil)
    }

}
