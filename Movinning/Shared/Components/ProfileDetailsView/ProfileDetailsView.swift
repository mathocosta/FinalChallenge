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
            levelLabel.text = "\(level) "+NSLocalizedString("Points", comment: "")
        }
    }
    
    let user: User
    let tapAction: ((User) -> Void)

    lazy var imageView: RoundedImageView = {
        let imageView = RoundedImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "avatar-placeholder")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.itemTitleLargeCondensed
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .textColor
        label.text = self.name
        return label
    }()

    lazy var levelLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.bodySmall
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .textColor
        label.text = "Nível \(level)"
        return label
    }()

    init(frame: CGRect = .zero, name: String, level: Int, user: User, action: @escaping (User) -> Void) {
        self.name = name
        self.level = level
        self.user = user
        self.tapAction = action
        super.init(frame: frame)
        setupView()

        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:))))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func handleTapGesture(_ sender: UITapGestureRecognizer? = nil) {
        self.tapAction(self.user)
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
        imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true

        nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 13).isActive = true
        nameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 250).isActive = true

        levelLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5).isActive = true
        levelLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        levelLabel.heightAnchor.constraint(equalToConstant: levelLabel.intrinsicContentSize.height).isActive = true
    }

    func setupAdditionalConfiguration() {

    }
}
