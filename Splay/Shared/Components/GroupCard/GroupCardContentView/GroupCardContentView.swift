//
//  GroupCardContentView.swift
//  Splay
//
//  Created by Paulo José on 25/09/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit

class GroupCardContentView: UIView, CustomView {
    
    static let height = 112

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .cardStyle
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Clube da Luluzinha"
        return label
    }()

    lazy var detailLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .cardDetailStyle
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Parquelândia, Fortaleza"
        return label
    }()
    
    lazy var usersPhotoView: UsersPhotoView = {
        let view = UsersPhotoView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        self.setRoundedLayer(color: .dark)
        setupView()
    }

}

extension GroupCardContentView: CodeView {
    func buildViewHierarchy() {
        addSubview(titleLabel)
        addSubview(detailLabel)
        addSubview(usersPhotoView)
    }

    func setupConstraints() {
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 17.0).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 14.0).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant: titleLabel.intrinsicContentSize.width).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: titleLabel.intrinsicContentSize.height).isActive = true

        detailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2).isActive = true
        detailLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor).isActive = true
        detailLabel.widthAnchor.constraint(equalToConstant: detailLabel.intrinsicContentSize.width).isActive = true
        detailLabel.heightAnchor.constraint(equalToConstant: detailLabel.intrinsicContentSize.height).isActive = true
        
        usersPhotoView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive = true
        usersPhotoView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        usersPhotoView.widthAnchor.constraint(equalToConstant: 104).isActive = true
        usersPhotoView.heightAnchor.constraint(equalToConstant: 32.0).isActive = true
    }

    func setupAdditionalConfiguration() {

    }
}
