//
//  TeamRankingView.swift
//  Movinning
//
//  Created by Paulo José on 30/10/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit

class TeamRankingView: UIView {
    
    enum State {
        case firstQuery
        case ready
        case error
    }

    var state: State = .firstQuery {
        didSet {
            switch state {
            case .firstQuery:
                loadingStackView.isHidden = false
                emptyStateStackView.isHidden = true
                loadingActivityIndicator.startAnimating()
                loadingActivityIndicator.isHidden = false
                loadingLabel.isHidden = false
                tableView.isHidden = true
            case .ready:
                tableView.isHidden = false
                emptyStateStackView.isHidden = true
                loadingStackView.isHidden = true
                loadingActivityIndicator.stopAnimating()
                tableView.reloadData()
            case .error:
                tableView.isHidden = true
                emptyStateStackView.isHidden = false
                loadingStackView.isHidden = true
                loadingActivityIndicator.stopAnimating()
            }
        }
    }

    weak var parentVC: TeamRankingViewController?

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
    
    let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .body
        label.textColor = .textColor
        label.textAlignment = .center
        label.text = NSLocalizedString("An Error has occured", comment: "")
        return label
    }()

    let emptyStateButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.textColor, for: .normal)
        button.titleLabel?.font = .action
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(NSLocalizedString("Try again", comment: ""), for: .normal)
        return button
    }()

    lazy var emptyStateStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [emptyStateLabel, emptyStateButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillProportionally
        stackView.axis = .vertical
        stackView.spacing = 10.0
        return stackView
    }()

    init(frame: CGRect, parentVC: TeamRankingViewController) {
        self.parentVC = parentVC
        self.state = .firstQuery
        super.init(frame: frame)
        self.backgroundColor = .backgroundColor
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension TeamRankingView: CodeView {
    func buildViewHierarchy() {
        addSubview(emptyStateStackView)
        addSubview(loadingStackView)
        addSubview(tableView)
    }

    func setupConstraints() {
        loadingStackView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
        loadingStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
        loadingStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
        loadingStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        emptyStateStackView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
        emptyStateStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
        emptyStateStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
        emptyStateStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true

        tableView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }

    func setupAdditionalConfiguration() {
    }
}
