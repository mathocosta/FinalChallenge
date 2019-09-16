//
//  TeamEntranceViewController.swift
//  FinalChallenge
//
//  Created by Matheus Oliveira Costa on 04/09/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit

class TeamEntranceViewController: UIViewController {

    // MARK: - Properties
    private let teamEntranceView: TeamEntranceView
    private let team: Team

    weak var coordinator: TeamTabCoordinator?

    // MARK: - Lifecycle
    init(team: Team) {
        self.team = team
        self.teamEntranceView = TeamEntranceView()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = teamEntranceView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = team.name
        teamEntranceView.teamTitleLabel.text = team.name
        teamEntranceView.onJoinTeam = selectTeamForLoggedUser
    }

    // MARK: - Actions
    func selectTeamForLoggedUser() {
        // Adicionar time ao usuário
        if let loggedUser = UserManager.getLoggedUser() {
            SessionManager.current.add(user: loggedUser, to: team) { (result) in
                switch result {
                case .success:
                    DispatchQueue.main.async { [unowned self] in
                        // Retorna para a tela de abertura do time
                        self.coordinator?.showDetails(of: self.team)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }

}
