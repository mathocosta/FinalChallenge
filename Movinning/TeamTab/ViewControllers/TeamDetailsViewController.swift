//
//  TeamPresentationViewController.swift
//  FinalChallenge
//
//  Created by Matheus Oliveira Costa on 04/09/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit
import CoreData

class TeamDetailsViewController: UIViewController, LoaderView {

    var loadingView: LoadingView = {
        let view = LoadingView()
        return view
    }()

    // MARK: - Properties
    private let teamDetailsView: TeamDetailsView
    private let team: Team

    weak var coordinator: TeamTabCoordinator?

    // MARK: - Lifecycle
    init(team: Team) {
        self.team = team
        self.teamDetailsView = TeamDetailsView(team: team)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = teamDetailsView
        teamDetailsView.onShowMembers = self.onShowMembers
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = team.name
        teamDetailsView.teamTitleLabel.text = team.name ?? ""

        var location = ""
        if let city = team.city, city != "" {
            location = "\(city)"
        }
        if let neighborhood = team.neighborhood, neighborhood != "" {
            location = "\(neighborhood)"+(location != "" ? ", "+location : "")
        }
        teamDetailsView.teamDetailLabel.text = location

        let quitTeamBarButton = UIBarButtonItem(
            title: NSLocalizedString("Quit", comment: ""),
            style: .plain, target: self, action: #selector(quitTeamTapped(_:)))
        quitTeamBarButton.tintColor = .fadedRed
        navigationItem.rightBarButtonItem = quitTeamBarButton
    }

    // MARK: - Actions
    @objc func quitTeamTapped(_ sender: UIBarButtonItem? = nil) {
        let alert = UIAlertController.cancelAlert(
            title: NSLocalizedString("Attention", comment: ""),
            message: NSLocalizedString("Leave team message", comment: "")
        ) {
            self.startLoader()

            guard let loggedUser = UserManager.getLoggedUser() else { return }
            SessionManager.current.remove(user: loggedUser, from: self.team).done(on: .main) { _ in
                self.stopLoader()
                self.coordinator?.showTeamList()
            }.catch(on: .main) { _ in
                self.stopLoader()
                self.presentAlert(with: NSLocalizedString("An Error has occured", comment: ""),
                                  message: NSLocalizedString("Try again", comment: ""),
                                  completion: {
                                    self.quitTeamTapped()
                }) {
                    print("Cancelado")
                }
            }
        }

        present(alert, animated: true, completion: nil)
    }

    func onShowMembers() {
        guard let coordinator = coordinator else { return }
        coordinator.showTeamMembers(of: team)
    }

}
