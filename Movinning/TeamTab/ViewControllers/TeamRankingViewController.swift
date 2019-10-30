//
//  TeamRankingViewController.swift
//  Movinning
//
//  Created by Paulo José on 30/10/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit

class TeamRankingViewController: UIViewController {

    var teamRankingView: TeamRankingView?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.teamRankingView = TeamRankingView(frame: .zero, parentVC: self)
        self.view = teamRankingView
        self.title = "Ranking"
    }

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension TeamRankingViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TeamRankingViewCell.self),
                                                       for: indexPath) as? TeamRankingViewCell else {
            return UITableViewCell()
        }

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return TeamRankingViewCell.height
    }
}
