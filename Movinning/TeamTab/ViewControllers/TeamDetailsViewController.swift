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
        self.teamDetailsView = TeamDetailsView()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = teamDetailsView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = team.name
        teamDetailsView.teamTitleLabel.text = team.name ?? ""

        let quitTeamBarButton = UIBarButtonItem(
            title: NSLocalizedString("Quit", comment: ""),
            style: .plain, target: self, action: #selector(quitTeamTapped(_:)))
        quitTeamBarButton.tintColor = .red
        navigationItem.rightBarButtonItem = quitTeamBarButton
    }

    // MARK: - Actions
    @objc func quitTeamTapped(_ sender: UIBarButtonItem) {

        self.startLoader()

        guard let loggedUser = UserManager.getLoggedUser() else { return }
        SessionManager.current.remove(user: loggedUser, from: team).done(on: .main) { (_) in
            self.stopLoader()
            self.coordinator?.showTeamList()
        }.catch(on: .main) { (error) in
            self.stopLoader()
            print(error.localizedDescription)
        }
    }

}
