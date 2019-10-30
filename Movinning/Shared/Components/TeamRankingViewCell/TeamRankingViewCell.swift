//
//  TeamRankingViewCell.swift
//  Movinning
//
//  Created by Paulo José on 30/10/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit

class TeamRankingViewCell: UITableViewCell {
    
    static var height: CGFloat = 60

    var profileImage: UIImage? {
        didSet {
            profileImageView.image = profileImage
        }
    }
    
    lazy var positionlabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .itemTitleLargeCondensed
        label.text = "1"
        label.textColor = .textColor
        return label
    }()

    lazy var profileImageView: RoundedImageView = {
        let imageView = RoundedImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "avatar-placeholder") ?? UIImage()
        return imageView
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .textColor
        label.text = "Nome do usuário"
        label.font = .itemTitle
        return label
    }()

    lazy var pointsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .textColor
        label.text = "232 points"
        label.font = .itemDetail
        return label
    }()
        
    lazy var underlineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .textColor
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TeamRankingViewCell: CodeView {
    func buildViewHierarchy() {
        contentView.addSubview(positionlabel)
        contentView.addSubview(profileImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(pointsLabel)
        contentView.addSubview(underlineView)
    }

    func setupConstraints() {
        positionlabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        positionlabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 32).isActive = true
        positionlabel.heightAnchor.constraint(equalToConstant: positionlabel.intrinsicContentSize.height).isActive = true
        positionlabel.widthAnchor.constraint(equalToConstant: 38).isActive = true

        profileImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        profileImageView.leftAnchor.constraint(equalTo: positionlabel.rightAnchor, constant: 8).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 38).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 38).isActive = true

        nameLabel.topAnchor.constraint(equalTo: profileImageView.topAnchor).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 16).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -24).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: nameLabel.intrinsicContentSize.height).isActive = true

        pointsLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 0).isActive = true
        pointsLabel.leftAnchor.constraint(equalTo: nameLabel.leftAnchor).isActive = true
        pointsLabel.rightAnchor.constraint(equalTo: nameLabel.rightAnchor).isActive = true
        pointsLabel.heightAnchor.constraint(equalToConstant: pointsLabel.intrinsicContentSize.height).isActive = true

        underlineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        underlineView.leftAnchor.constraint(equalTo: profileImageView.leftAnchor).isActive = true
        underlineView.rightAnchor.constraint(equalTo: pointsLabel.rightAnchor).isActive = true
        underlineView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 12).isActive = true
    }

    func setupAdditionalConfiguration() {
    }
}
