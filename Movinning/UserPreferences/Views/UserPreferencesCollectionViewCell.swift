//
//  UserPreferencesCollectionViewCell.swift
//  Movinning
//
//  Created by Martônio Júnior on 01/11/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit

class UserPreferencesCollectionViewCell: UICollectionViewCell {
    var sportText: String = "" {
        didSet {
            titleLabel.text = NSLocalizedString(sportText, comment: "")
        }
    }

    var toggled: Bool = false

    // MARK: - Properties
    lazy var toggleImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = !toggled ? UIColor.green : UIColor.red
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.font = .itemTitle
        label.textColor = .textColor
        label.textAlignment = .center
        return label
    }()

    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.borderColor = UIColor.fadedRed.cgColor
        layer.borderWidth = 2
        layer.cornerRadius = frame.height / 2
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Actions
    @objc func toggleSelection(_ sender: UITapGestureRecognizer? = nil) {

    }
}

extension UserPreferencesCollectionViewCell: CodeView {
    func buildViewHierarchy() {
        addSubview(toggleImageView)
        addSubview(titleLabel)
    }

    func setupConstraints() {
        toggleImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        toggleImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        toggleImageView.widthAnchor.constraint(equalTo: toggleImageView.heightAnchor).isActive = true
        toggleImageView.heightAnchor.constraint(equalTo: self.heightAnchor, constant: -16).isActive = true

        titleLabel.leftAnchor.constraint(equalTo: toggleImageView.rightAnchor, constant: 4).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalTo: toggleImageView.heightAnchor).isActive = true
    }

    func setupAdditionalConfiguration() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(toggleSelection(_:)))
        self.addGestureRecognizer(gestureRecognizer)
    }
}
