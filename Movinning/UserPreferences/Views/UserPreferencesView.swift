//
//  UserPreferencesView.swift
//  Movinning
//
//  Created by Martônio Júnior on 01/11/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit

class UserPreferencesView: UIView {
    // MARK: - Properties
    lazy var textTimeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.text = NSLocalizedString("Free Time", comment: "")
        label.font = .sectionTitle
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var timeSegmentedControl: UISegmentedControl = {
        let items = ExerciseIntensity.allTypes.sorted(by: { $0.rawValue < $1.rawValue }).map { $0.title() }
        let time = UserDefaults.standard.practiceTime
        let control = UISegmentedControl(items: items)
        control.backgroundColor = .fadedRed
        control.setTitleTextAttributes([
            .foregroundColor: UIColor.textColor,
            .font: UIFont.itemDetail
        ], for: .selected)
        control.setTitleTextAttributes([
            .foregroundColor: UIColor.backgroundColor,
            .font: UIFont.itemDetail
        ], for: .normal)
        control.selectedSegmentIndex = time.index()
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()

    lazy var textSportsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.text = NSLocalizedString("User Preferences Title", comment: "")
        label.font = .sectionTitle
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    lazy var confirmButton: UIButton = {
        let button = UIButton()
        button.setTitle(NSLocalizedString("Confirm", comment: ""), for: UIControl.State.normal)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(nextButtonTapped(_:)), for: UIControl.Event.touchUpInside)
        button.setTitleColor(.fadedRed, for: UIControl.State.normal)
        button.setTitleColor(.textColor, for: UIControl.State.highlighted)
        button.titleLabel?.font = .action
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .backgroundColor
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Actions
    var onNextPage: (() -> Void)?
    @objc func nextButtonTapped(_ sender: UIButton) {
        guard let onNextPage = onNextPage else { return }
        onNextPage()
    }
}

extension UserPreferencesView: CodeView {
    func buildViewHierarchy() {
        addSubview(textTimeLabel)
        addSubview(timeSegmentedControl)
        addSubview(textSportsLabel)
        addSubview(collectionView)
        addSubview(confirmButton)
    }

    func setupConstraints() {
        textTimeLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        textTimeLabel.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 16).isActive = true
        textTimeLabel.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -16).isActive = true
        textTimeLabel.heightAnchor.constraint(equalToConstant: 68).isActive = true

        timeSegmentedControl.topAnchor.constraint(equalTo: textTimeLabel.bottomAnchor, constant: 16).isActive = true
        timeSegmentedControl.leftAnchor.constraint(
            equalTo: safeAreaLayoutGuide.leftAnchor, constant: 16).isActive = true
        timeSegmentedControl.rightAnchor.constraint(
            equalTo: safeAreaLayoutGuide.rightAnchor, constant: -16).isActive = true
        timeSegmentedControl.heightAnchor.constraint(equalToConstant: 32).isActive = true

        textSportsLabel.topAnchor.constraint(equalTo: timeSegmentedControl.bottomAnchor, constant: 16).isActive = true
        textSportsLabel.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 16).isActive = true
        textSportsLabel.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -16).isActive = true
        textSportsLabel.heightAnchor.constraint(equalToConstant: 52).isActive = true

        collectionView.topAnchor.constraint(equalTo: textSportsLabel.bottomAnchor, constant: 16).isActive = true
        collectionView.leftAnchor.constraint(equalTo: textSportsLabel.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: textSportsLabel.rightAnchor).isActive = true

        confirmButton.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 16).isActive = true
        confirmButton.leftAnchor.constraint(equalTo: textSportsLabel.leftAnchor).isActive = true
        confirmButton.rightAnchor.constraint(equalTo: textSportsLabel.rightAnchor).isActive = true
        confirmButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
        confirmButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
    }

    func setupAdditionalConfiguration() {

    }
}
