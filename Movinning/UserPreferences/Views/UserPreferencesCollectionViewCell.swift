//
//  UserPreferencesCollectionViewCell.swift
//  Movinning
//
//  Created by Martônio Júnior on 01/11/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit

class UserPreferencesCollectionViewCell: UICollectionViewCell {
    var sport: Sport? {
        didSet {
            guard let sport = sport else { return }
            titleLabel.text = NSLocalizedString(sport.name(), comment: "")
        }
    }

    var toggled: Bool = false {
        didSet {
            self.backgroundColor = toggled ? UIColor.fadedRed : UIColor.backgroundColor
            self.titleLabel.textColor = toggled ? UIColor.backgroundColor : UIColor.textColor
        }
    }

    // MARK: - Properties
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.textAlignment = .left
        label.font = .itemTitle
        label.textColor = toggled ? UIColor.backgroundColor : UIColor.textColor
        label.textAlignment = .center
        return label
    }()

    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.borderColor = UIColor.fadedRed.cgColor
        layer.borderWidth = 2
        layer.cornerRadius = frame.height / 2
        layer.masksToBounds = true

        let view = UIView()
        view.backgroundColor = .clear
        selectedBackgroundView = view
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UserPreferencesCollectionViewCell: CodeView {
    func buildViewHierarchy() {
        addSubview(titleLabel)
    }

    func setupConstraints() {
        titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -16).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalTo: self.heightAnchor, constant: -16).isActive = true
    }

    func setupAdditionalConfiguration() {

    }
}
