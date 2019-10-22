//
//  AchievmentItemView.swift
//  Movinning
//
//  Created by Paulo José on 08/10/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit

class AchievmentItemViewCell: UICollectionViewCell {

    static let height: CGFloat = 172
    static let width: CGFloat = 130

    lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "AchievmentIcon")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .bodySmall
        label.textColor = .textColor
        label.text = "Corredor"
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

extension AchievmentItemViewCell: CodeView {
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
        label.heightAnchor.constraint(equalToConstant: 22).isActive = true
    }

    func setupAdditionalConfiguration() {
    }

}
