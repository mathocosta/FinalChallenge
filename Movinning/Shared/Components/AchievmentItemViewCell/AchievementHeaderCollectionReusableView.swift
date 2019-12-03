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
        label.font = .bodySmall
        label.textColor = .textColor
        label.sizeToFit()
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
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
        label.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 7*16).isActive = true
    }

    func setupAdditionalConfiguration() {
    }

}
