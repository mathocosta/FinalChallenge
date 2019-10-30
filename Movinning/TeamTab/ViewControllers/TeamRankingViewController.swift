//
//  TeamRankingViewController.swift
//  Movinning
//
//  Created by Paulo José on 30/10/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit

class TeamRankingViewController: UIViewController {

    weak var coordinator: TeamTabCoordinator?

    var teamRankingView: TeamRankingView?
    var users = [User]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.teamRankingView = TeamRankingView(frame: .zero, parentVC: self)
        self.view = teamRankingView
        self.title = "Ranking"
        loadUsers()
    }

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func loadUsers() {
        guard let loggedUser = UserManager.getLoggedUser(),
            let userTeam = loggedUser.team else { return }

        teamRankingView?.isLoading = true
        SessionManager.current.users(from: userTeam, of: loggedUser).done(on: .main) {
            [weak self] users in
            self?.users.append(contentsOf: users)
            self?.teamRankingView?.tableView.reloadData()
        }.catch(on: .main) { error in
            print(error.localizedDescription)
            self.presentAlert(
                with: NSLocalizedString("An Error has occured", comment: ""),
                message: NSLocalizedString("Try again", comment: ""),
                completion: self.loadUsers
            )
        }.finally(on: .main) { [weak self] in
            self?.teamRankingView?.isLoading = false
        }
    }
}

extension TeamRankingViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: TeamRankingViewCell.self), for: indexPath
        ) as? TeamRankingViewCell else { return UITableViewCell() }

        let user = users[indexPath.row]
        cell.nameLabel.text = user.firstName
        cell.profileImage = UIImage(data: user.photo ?? Data())
        cell.pointsLabel.text = String(describing: user.points)
        cell.positionlabel.text = String(describing: indexPath.row + 1)

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return TeamRankingViewCell.height
    }
}
