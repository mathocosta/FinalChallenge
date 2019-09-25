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
        tableView.register(GroupCardView.self, forCellReuseIdentifier: "GroupCardView")

        return tableView
    }()

    let refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlValueChanged(_:)), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(
            string: "Fetching Weather Data ...",
            attributes: nil
        )

        return refreshControl
    }()

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var onRefreshControl: (() -> Void)?
    @objc func refreshControlValueChanged(_ sender: UIRefreshControl) {
        guard let onRefreshControl = onRefreshControl else { return }
        onRefreshControl()
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

    func setupAdditionalConfiguration() {
//        resultsTableView.refreshControl = refreshControl
    }
}
