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

    lazy var fetchedResultsController: NSFetchedResultsController<Team> = {
        let fetchRequest: NSFetchRequest<Team> = Team.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        let resultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: CoreStataStore.context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )

        return resultsController
    }()

    // MARK: - Lifecycle
    override func loadView() {
        let teamListView = TeamListView()
        view = teamListView

        teamListView.resultsTableView.delegate = self
        teamListView.resultsTableView.dataSource = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Grupos"

        let createTeamBarButton = UIBarButtonItem(
            barButtonSystemItem: .add, target: self, action: #selector(createTeamBarButtonTapped(_:)))
        navigationItem.rightBarButtonItem = createTeamBarButton
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        defer {
            if let teamListView = view as? TeamListView {
                teamListView.resultsTableView.reloadData()
            }
        }

        do {
            try fetchedResultsController.performFetch()
        } catch let error {
            print(error.localizedDescription)
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
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultsCell", for: indexPath)
        let team = fetchedResultsController.object(at: indexPath)

        cell.textLabel?.text = team.name

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedTeam = fetchedResultsController.object(at: indexPath)
        coordinator?.showEntrance(of: selectedTeam)
    }
}
