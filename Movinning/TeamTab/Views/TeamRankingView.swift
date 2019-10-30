//
//  TeamRankingView.swift
//  Movinning
//
//  Created by Paulo José on 30/10/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit

class TeamRankingView: UIView {
    
    let parentVC: TeamRankingViewController

    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .backgroundColor
        tableView.separatorStyle = .none
        tableView.delegate = self.parentVC
        tableView.dataSource = self.parentVC
        tableView.register(TeamRankingViewCell.self, forCellReuseIdentifier: String(describing: TeamRankingViewCell.self))
        return tableView
    }()

    init(frame: CGRect, parentVC: TeamRankingViewController) {
        self.parentVC = parentVC
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension TeamRankingView: CodeView {
    func buildViewHierarchy() {
        addSubview(tableView)
    }
    
    func setupConstraints() {
        tableView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    func setupAdditionalConfiguration() {
    }
}
