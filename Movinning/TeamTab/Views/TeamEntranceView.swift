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
    lazy var teamImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "GroupIcon")
        return imageView
    }()

    lazy var teamTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .itemTitleLargeCondensed
        label.textColor = .textColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var teamLevelSubtitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .bodySmall
        label.textColor = .textColor
        label.translatesAutoresizingMaskIntoConstraints = false
        // TODO: Remover
        label.text = "Nível 12"
        return label
    }()

    lazy var teamDetailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .bodySmall
        label.textColor = .textColor
        label.text = "Parquelândia, Fortaleza"
        return label
    }()

    lazy var joinTeamButton: CustomButtonView = {
        let button = CustomButtonView(frame: .zero, label: NSLocalizedString("Join Team", comment: ""))
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    lazy var conquistasView: AchievmentListView = {
        let view = AchievmentListView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var participantesView: GroupMemberListView = {
        let view = GroupMemberListView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var seeMoreAchievmentsLabel: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("See more", comment: ""), for: .normal)
        button.setTitleColor(.textColor, for: .normal)
        button.titleLabel?.font = .body
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(seeMoreAchievmentsTapped(_:))))
        return button
    }()

    lazy var seeMoreMembersLabel: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("See more", comment: ""), for: .normal)
        button.setTitleColor(.textColor, for: .normal)
        button.titleLabel?.font = .body
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(seeMoreMembersTapped(_:))))
        return button
    }()

    lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .backgroundColor
        return view
    }()

    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .backgroundColor
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    // MARK: - Lifecycle
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        backgroundColor = .backgroundColor
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

    @objc func seeMoreAchievmentsTapped(_ sender: UITapGestureRecognizer) {
        print("See more achievments")
    }

    @objc func seeMoreMembersTapped(_ sender: UITapGestureRecognizer) {
        print("See more Members")
    }
}

extension TeamEntranceView: CodeView {
    func buildViewHierarchy() {
        contentView.addSubview(teamImageView)
        contentView.addSubview(teamTitleLabel)
        contentView.addSubview(teamLevelSubtitleLabel)
        contentView.addSubview(teamDetailLabel)
        contentView.addSubview(joinTeamButton)
        contentView.addSubview(conquistasView)
        contentView.addSubview(seeMoreAchievmentsLabel)
        contentView.addSubview(participantesView)
        contentView.addSubview(seeMoreMembersLabel)

        scrollView.addSubview(contentView)

        addSubview(scrollView)
    }

    func setupConstraints() {
        teamImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
        teamImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        teamImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        teamImageView.heightAnchor.constraint(equalToConstant: 134).isActive = true

        teamTitleLabel.topAnchor.constraint(equalTo: teamImageView.bottomAnchor, constant: 15).isActive = true
        teamTitleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        teamTitleLabel.heightAnchor.constraint(equalToConstant: 38).isActive = true

        teamLevelSubtitleLabel.topAnchor.constraint(equalTo: teamTitleLabel.bottomAnchor).isActive = true
        teamLevelSubtitleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        teamLevelSubtitleLabel.heightAnchor.constraint(equalToConstant: 22).isActive = true

        teamDetailLabel.topAnchor.constraint(equalTo: teamLevelSubtitleLabel.bottomAnchor).isActive = true
        teamDetailLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        teamDetailLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true

        joinTeamButton.widthAnchor.constraint(equalToConstant: 164).isActive = true
        joinTeamButton.heightAnchor.constraint(equalToConstant: 46).isActive = true
        joinTeamButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        joinTeamButton.topAnchor.constraint(equalTo: teamDetailLabel.bottomAnchor, constant: 14).isActive = true

        conquistasView.topAnchor.constraint(equalTo: joinTeamButton.bottomAnchor, constant: 34).isActive = true
        conquistasView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        conquistasView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        conquistasView.heightAnchor.constraint(equalToConstant: 259).isActive = true

        seeMoreAchievmentsLabel.topAnchor.constraint(equalTo: conquistasView.bottomAnchor, constant: 8).isActive = true
        seeMoreAchievmentsLabel.rightAnchor.constraint(equalTo: contentView.layoutMarginsGuide.rightAnchor).isActive = true
        seeMoreAchievmentsLabel.heightAnchor.constraint(equalToConstant: seeMoreAchievmentsLabel.intrinsicContentSize.height).isActive = true

        participantesView.topAnchor.constraint(equalTo: seeMoreAchievmentsLabel.bottomAnchor, constant: 23).isActive = true
        participantesView.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        participantesView.heightAnchor.constraint(equalToConstant: 321).isActive = true
        participantesView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true

        seeMoreMembersLabel.topAnchor.constraint(equalTo: participantesView.bottomAnchor, constant: 8).isActive = true
        seeMoreMembersLabel.rightAnchor.constraint(equalTo: participantesView.layoutMarginsGuide.rightAnchor).isActive = true
        seeMoreMembersLabel.heightAnchor.constraint(equalToConstant: seeMoreMembersLabel.intrinsicContentSize.height).isActive = true

        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo: scrollView.rightAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        contentView.heightAnchor.constraint(equalToConstant: 1100).isActive = true

        scrollView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }

    func setupAdditionalConfiguration() {
        joinTeamButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(joinTeamTapped(_:))))
    }
}
