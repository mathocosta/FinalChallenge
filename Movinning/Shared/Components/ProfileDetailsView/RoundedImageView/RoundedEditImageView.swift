//
//  RoundedEditImageView.swift
//  Splay
//
//  Created by Martônio Júnior on 24/09/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit

class RoundedEditImageView: UIView {

    lazy var editLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Edit", comment: "")
        label.backgroundColor = UIColor.backgroundColor.withAlphaComponent(0.5)
        label.textColor = .textColor
        label.textAlignment = .center
        label.font = .bodySmall
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var imageView: RoundedImageView = {
        let imageView = RoundedImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "avatar-placeholder")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension RoundedEditImageView: CodeView {
    func buildViewHierarchy() {
        addSubview(imageView)
        addSubview(editLabel)
    }

    func setupConstraints() {
        imageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        imageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true

        editLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        editLabel.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        editLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        editLabel.topAnchor.constraint(equalTo: self.centerYAnchor, constant: 16).isActive = true
        //editLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }

    func setupAdditionalConfiguration() {

    }
}
