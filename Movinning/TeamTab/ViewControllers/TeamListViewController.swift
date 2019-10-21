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

    private let teamListView: TeamListView

    private var teams = [Team]()
    private var filteredTeams = [Team]()

    lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Teams"

        return searchController
    }()

    private var searchBarIsEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }

    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }

    // MARK: - Lifecycle
    init() {
        self.teamListView = TeamListView()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = teamListView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = NSLocalizedString("Teams", comment: "")

        teamListView.resultsTableView.delegate = self
        teamListView.resultsTableView.dataSource = self
        teamListView.onRefreshControl = updateTeamList

        let createTeamBarButton = UIBarButtonItem(
            barButtonSystemItem: .add, target: self, action: #selector(createTeamBarButtonTapped(_:)))
        navigationItem.rightBarButtonItem = createTeamBarButton
        navigationItem.searchController = searchController

        // TODO: Esse método está aqui apenas porque ainda não funciona corretamente,
        // depois é para ser movido para a viewWillAppear
        updateTeamList()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    private func updateTeamList() {
        SessionManager.current.listTeams().done(on: .main) { [weak self] teams in
            self?.teams.append(contentsOf: teams)
            self?.teamListView.refreshControl.endRefreshing()
            self?.teamListView.resultsTableView.reloadData()
        }.catch(on: .main) { error in
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
        return isFiltering ? filteredTeams.count : teams.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "GroupCardView", for: indexPath) as? GroupCardView else {
                return UITableViewCell()
        }

        let team: Team
        if isFiltering {
            team = filteredTeams[indexPath.row]
        } else {
            team = teams[indexPath.row]
        }

        cell.team = team

        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return NSLocalizedString("Sugestions", comment: "")
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.font = .sectionTitle
        header.backgroundView?.backgroundColor = .backgroundColor
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(GroupCardView.height)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UITableViewHeaderFooterView(frame: CGRect(x: 0, y: 0, width: 30, height: 120))
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        headerView.backgroundView = backgroundView
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedTeam: Team
        if isFiltering {
            selectedTeam = filteredTeams[indexPath.row]
        } else {
            selectedTeam = teams[indexPath.row]
        }
        coordinator?.showEntrance(of: selectedTeam)
    }
}

// MARK: - UISearchControllerDelegate
extension TeamListViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filterContent(for: searchText)
        }
    }

    private func filterContent(for searchText: String) {
        filteredTeams = teams.filter({ (team) -> Bool in
            guard let teamName = team.name else { return false }
            return teamName.lowercased().contains(searchText.lowercased())
        })

        teamListView.resultsTableView.reloadData()
    }

}
