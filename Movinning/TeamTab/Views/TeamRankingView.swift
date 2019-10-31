//
//  TeamRankingView.swift
//  Movinning
//
//  Created by Paulo José on 30/10/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit

class TeamRankingView: UIView {

    weak var parentVC: TeamRankingViewController?

    var isLoading = false {
        didSet {
            tableView.isHidden = isLoading
            loadingLabel.isHidden = !isLoading
            loadingActivityIndicator.isHidden = !isLoading
            isLoading ? loadingActivityIndicator.startAnimating() : loadingActivityIndicator.stopAnimating()
        }
    }

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

    let loadingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .textColor
        label.textAlignment = .center
        label.font = .body
        label.text = NSLocalizedString("Loading", comment: "")
        return label
    }()

    let loadingActivityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = .textColor
        activityIndicator.hidesWhenStopped = true

        return activityIndicator
    }()

    lazy var loadingStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [loadingLabel, loadingActivityIndicator])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillProportionally
        stackView.axis = .vertical
        stackView.spacing = 20.0
        return stackView
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
        addSubview(loadingStackView)
        addSubview(tableView)
    }

    func setupConstraints() {
        loadingStackView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
        loadingStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
        loadingStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
        loadingStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true

        tableView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }

    func setupAdditionalConfiguration() {
    }
}
