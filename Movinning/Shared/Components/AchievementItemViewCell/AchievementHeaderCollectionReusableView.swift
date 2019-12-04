//
//  AchievementHeaderCollectionReusableView.swift
//  Movinning
//
//  Created by Thalia Freitas on 02/12/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit

class AchievementHeaderCollectionReusableView: UICollectionReusableView {

    lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .sectionTitle
        label.textColor = .textColor
        label.sizeToFit()
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .backgroundColor
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension AchievementHeaderCollectionReusableView: CodeView {
    func buildViewHierarchy() {
        addSubview(label)
    }

    func setupConstraints() {
        label.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive = true
        label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8).isActive = true
    }

    func setupAdditionalConfiguration() {
    }

}
