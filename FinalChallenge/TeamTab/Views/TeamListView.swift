//
//  TeamListView.swift
//  FinalChallenge
//
//  Created by Matheus Oliveira Costa on 05/09/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit

class TeamListView: UIView {

    let resultsTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ResultsCell")

        return tableView
    }()

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - CodeView
extension TeamListView: CodeView {
    func buildViewHierarchy() {
        addSubview(resultsTableView)
    }

    func setupConstraints() {
        resultsTableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        resultsTableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true
        resultsTableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
        resultsTableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
    }

    func setupAdditionalConfiguration() {}
}
