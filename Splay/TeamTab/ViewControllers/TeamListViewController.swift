//
//  TeamListViewController.swift
//  FinalChallenge
//
//  Created by Matheus Oliveira Costa on 05/09/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit
import CoreData

class TeamListViewController: UIViewController {

    // MARK: - Properties
    weak var coordinator: TeamTabCoordinator?

    var teams = [Team]()

    // MARK: - Lifecycle
    override func loadView() {
        let teamListView = TeamListView()
        view = teamListView

        teamListView.resultsTableView.delegate = self
        teamListView.resultsTableView.dataSource = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = NSLocalizedString("Teams", comment: "")

        let createTeamBarButton = UIBarButtonItem(
            barButtonSystemItem: .add, target: self, action: #selector(createTeamBarButtonTapped(_:)))
        navigationItem.rightBarButtonItem = createTeamBarButton

        // TODO: Esse método está aqui apenas porque ainda não funciona corretamente,
        // depois é para ser movido para a viewWillAppear
        updateTeamList()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    private func updateTeamList() {
        SessionManager.current.listTeams { (result) in
            switch result {
            case .success(let newTeams):
                self.teams.append(contentsOf: newTeams)

                DispatchQueue.main.async {
                    if let teamListView = self.view as? TeamListView {
                        teamListView.resultsTableView.reloadData()
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    // MARK: - Actions
    @objc func createTeamBarButtonTapped(_ sender: UIBarButtonItem) {
        coordinator?.showCreateTeam()
    }

}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension TeamListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teams.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultsCell", for: indexPath)
        let team = teams[indexPath.row]

        cell.textLabel?.text = team.name

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedTeam = teams[indexPath.row]
        coordinator?.showEntrance(of: selectedTeam)
    }
}
