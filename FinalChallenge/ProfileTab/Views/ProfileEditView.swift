//
//  ProfileDetailsView.swift
//  FinalChallenge
//
//  Created by Paulo José on 06/09/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit

class ProfileEditView: UIView {

    lazy var profileImage: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .blue
        return view
    }()

    lazy var nameInput: Input = {
        let input = Input(frame: .zero, label: "Nome")
        input.translatesAutoresizingMaskIntoConstraints = false
        return input
    }()

    lazy var emailInput: Input = {
        let input = Input(frame: .zero, label: "Email")
        input.translatesAutoresizingMaskIntoConstraints = false
        return input
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension ProfileEditView: CodeView {
    func buildViewHierarchy() {
        addSubview(profileImage)
        addSubview(nameInput)
        addSubview(emailInput)
    }

    func setupConstraints() {
        profileImage.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        profileImage.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor, constant: 38).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 119).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 113).isActive = true

        nameInput.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 31).isActive = true
        nameInput.leftAnchor.constraint(equalTo: self.layoutMarginsGuide.leftAnchor).isActive = true
        nameInput.rightAnchor.constraint(equalTo: self.layoutMarginsGuide.rightAnchor).isActive = true
        nameInput.heightAnchor.constraint(equalToConstant: Input.height).isActive = true

        emailInput.topAnchor.constraint(equalTo: nameInput.bottomAnchor, constant: 31).isActive = true
        emailInput.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor).isActive = true
        emailInput.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor).isActive = true
        emailInput.heightAnchor.constraint(equalToConstant: Input.height).isActive = true
    }

    func setupAdditionalConfiguration() {

    }

}
