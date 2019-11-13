//
//  TeamListView.swift
//  FinalChallenge
//
//  Created by Matheus Oliveira Costa on 05/09/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit

class TeamListView: UIView {

    enum State {
        case firstQuery
        case loadingMoreResults
        case ready
        case error
    }

    var state: State {
        didSet {
            switch state {
            case .firstQuery:
                resultsTableView.isHidden = true
                loadingStackView.isHidden = false
                emptyStateStackView.isHidden = true
                loadingActivityIndicator.isHidden = false
                loadingActivityIndicator.startAnimating()
            case .ready:
                resultsTableView.isHidden = false
                loadingStackView.isHidden = true
                emptyStateStackView.isHidden = true
                loadingActivityIndicator.stopAnimating()
                resultsTableViewLoadingSpinner.stopAnimating()
                resultsTableView.tableFooterView = UIView()
                resultsTableView.tableFooterView?.isHidden = true
                resultsTableView.reloadData()
            case .loadingMoreResults:
                resultsTableViewLoadingSpinner.startAnimating()
                resultsTableView.tableFooterView?.isHidden = false
                emptyStateStackView.isHidden = true
                resultsTableView.tableFooterView = resultsTableViewLoadingSpinner
            case .error:
                resultsTableView.isHidden = true
                loadingStackView.isHidden = true
                emptyStateStackView.isHidden = false
                loadingActivityIndicator.isHidden = true
            }
        }
    }

    let resultsTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(GroupCardView.self, forCellReuseIdentifier: "GroupCardView")
        tableView.separatorStyle = .none
        tableView.backgroundColor = .backgroundColor
        tableView.isHidden = true
        return tableView
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

    lazy var resultsTableViewLoadingSpinner: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator.color = .textColor
        activityIndicator.frame = CGRect(x: 0.0, y: 0.0, width: resultsTableView.bounds.width, height: 70.0)
        activityIndicator.hidesWhenStopped = true

        return activityIndicator
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
        stackView.isHidden = true
        return stackView
    }()

    override init(frame: CGRect = .zero) {
        self.state = .firstQuery
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

    var onTryAgain: (() -> Void)?
    @objc func handleTryAgainButton(_ sender: UITapGestureRecognizer? = nil) {
        guard let onTryAgain = onTryAgain else { return }
        self.state = .firstQuery
        onTryAgain()
    }
}

// MARK: - CodeView
extension TeamListView: CodeView {
    func buildViewHierarchy() {
        addSubview(loadingStackView)
        addSubview(resultsTableView)
        addSubview(emptyStateStackView)
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

        resultsTableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        resultsTableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true
        resultsTableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
        resultsTableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true

    }

    func setupAdditionalConfiguration() {
          emptyStateButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTryAgainButton(_:))))
    }
}
