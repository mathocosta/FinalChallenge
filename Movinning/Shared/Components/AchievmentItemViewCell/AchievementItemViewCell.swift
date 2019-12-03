//
//  AchievmentItemView.swift
//  Movinning
//
//  Created by Paulo José on 08/10/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit

class AchievementItemViewCell: UICollectionViewCell {

    static let height: CGFloat = 192
    static let width: CGFloat = 130

    lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "AchievmentIcon")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    lazy var label: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: CGFloat.greatestFiniteMagnitude))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .bodySmall
        label.textColor = .textColor
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.text = "Corredor Corredor Corredor Corredor Corredor Corredor Corredor Corredor"
        label.sizeToFit()
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension AchievementItemViewCell: CodeView {
    func buildViewHierarchy() {
        addSubview(iconImageView)
        addSubview(label)
    }

    func setupConstraints() {
        iconImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        iconImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        iconImageView.widthAnchor.constraint(equalToConstant: 130).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 134).isActive = true

        label.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 16).isActive = true
        label.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        label.heightAnchor.constraint(equalToConstant: label.bounds.height).isActive = true
        label.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true

    }

    func setupAdditionalConfiguration() {
    }

}
