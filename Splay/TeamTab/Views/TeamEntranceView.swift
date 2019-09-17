//
//  TeamEntranceView.swift
//  FinalChallenge
//
//  Created by Matheus Oliveira Costa on 04/09/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit

class TeamEntranceView: UIView {

    // MARK: - Properties
    let teamImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.borderWidth = 1.5
        imageView.layer.borderColor = UIColor.blue.cgColor

        return imageView
    }()

    let teamTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 28, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    let teamLevelSubtitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        // TODO: Remover
        label.text = "Nível 12"

        return label
    }()

    let joinTeamButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("Join Team", comment: ""), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.contentEdgeInsets = UIEdgeInsets(top: 11, left: 30, bottom: 11, right: 30)
        button.addTarget(self, action: #selector(joinTeamTapped(_:)), for: .touchUpInside)

        return button
    }()

    // MARK: - Lifecycle
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        backgroundColor = .white

        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Actions
    var onJoinTeam: (() -> Void)?
    @objc func joinTeamTapped(_ sender: UIButton) {
        guard let onJoinTeam = onJoinTeam else { return }
        onJoinTeam()
    }
}

extension TeamEntranceView: CodeView {
    func buildViewHierarchy() {
        addSubview(teamImageView)
        addSubview(teamTitleLabel)
        addSubview(teamLevelSubtitleLabel)
        addSubview(joinTeamButton)
    }

    func setupConstraints() {
        teamImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        teamImageView.trailingAnchor.constraint(
            equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -105).isActive = true
        teamImageView.leadingAnchor.constraint(
            equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 105).isActive = true
        teamImageView.heightAnchor.constraint(equalToConstant: 130).isActive = true

        teamTitleLabel.topAnchor.constraint(equalTo: teamImageView.bottomAnchor, constant: 20).isActive = true
        teamTitleLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
        teamTitleLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true

        teamLevelSubtitleLabel.topAnchor.constraint(equalTo: teamTitleLabel.bottomAnchor, constant: 5).isActive = true
        teamLevelSubtitleLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
        teamLevelSubtitleLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true

        joinTeamButton.topAnchor.constraint(equalTo: teamLevelSubtitleLabel.bottomAnchor, constant: 20).isActive = true
        joinTeamButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }

    func setupAdditionalConfiguration() {}
}
