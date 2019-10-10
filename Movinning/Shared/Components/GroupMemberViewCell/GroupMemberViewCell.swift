//
//  GroupMemberViewCell.swift
//  Movinning
//
//  Created by Paulo José on 10/10/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit

class GroupMemberViewCell: UICollectionViewCell {
    
    static var width: CGFloat = 86
    static var height: CGFloat = 118
    
    lazy var profileImageView: RoundedImageView = {
        let view = RoundedImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "AchievmentIcon")
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .textColor
        label.font = .bodySmall
        label.text = "Paulo José"
        label.textAlignment = .center
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

extension GroupMemberViewCell: CodeView {
    func buildViewHierarchy() {
        addSubview(profileImageView)
        addSubview(nameLabel)
    }
    
    func setupConstraints() {
        profileImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 74).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 74).isActive = true
        profileImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 2).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: nameLabel.intrinsicContentSize.height).isActive = true
    }
    
    func setupAdditionalConfiguration() {
        
    }
    
    
}
