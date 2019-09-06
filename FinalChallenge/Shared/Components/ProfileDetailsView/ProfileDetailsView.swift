//
//  ProfileDetails.swift
//  FinalChallenge
//
//  Created by Paulo José on 04/09/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit

class ProfileDetailsView: UIView {

    var name: String {
        didSet {
            nameLabel.text = name
        }
    }

    var level: Int {
        didSet {
            levelLabel.text = "Nível \(level)"
        }
    }

    lazy var imageView: UIView = { //Trocar para UIImageView quando
        let view = UIView()
        view.backgroundColor = .blue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = self.name
        return label
    }()

    lazy var levelLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = "Nível \(level)"
        return label
    }()

    init(frame: CGRect = .zero, name: String, level: Int) {
        self.name = name
        self.level = level

        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension ProfileDetailsView: CodeView {
    func buildViewHierarchy() {
        addSubview(imageView)
        addSubview(nameLabel)
        addSubview(levelLabel)
    }

    func setupConstraints() {
        imageView.widthAnchor.constraint(equalToConstant: 119).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 119).isActive = true
        imageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        imageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true

        nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 13).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: nameLabel.intrinsicContentSize.height).isActive = true

        levelLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5).isActive = true
        levelLabel.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        levelLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        levelLabel.heightAnchor.constraint(equalToConstant: levelLabel.intrinsicContentSize.height).isActive = true
    }

    func setupAdditionalConfiguration() {

    }
}