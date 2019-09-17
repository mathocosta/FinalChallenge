//
//  ProfileDetailsView.swift
//  FinalChallenge
//
//  Created by Paulo José on 06/09/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit

class ProfileEditView: UIView {

    var profileImageConstrait: NSLayoutConstraint?

    lazy var profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "avatar-placeholder")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    lazy var editProfileImageButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Editar imagem", for: .normal)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(editProfileImageTapped(sender:)), for: .touchUpInside)
        return button
    }()

    lazy var nameInput: Input = {
        let input = Input(frame: .zero, label: "Nome")
        input.translatesAutoresizingMaskIntoConstraints = false
        input.inputTextField.keyboardType = .alphabet
        input.inputTextField.delegate = self
        return input
    }()

    lazy var emailInput: Input = {
        let input = Input(frame: .zero, label: "Email")
        input.translatesAutoresizingMaskIntoConstraints = false
        input.inputTextField.keyboardType = .emailAddress
        input.inputTextField.delegate = self
        return input
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupView()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillDismiss(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var onLogout: (() -> Void)?
    @objc func logoutButtonTapped(_ sender: UIButton) {
        guard let onLogout = onLogout else { return }
        onLogout()
    }

    var onEditProfileImage: ((UIButton) -> Void)?
    @objc func editProfileImageTapped(sender: UIButton) {
        guard let onEditProfileImage = onEditProfileImage else { return }
        onEditProfileImage(sender)
    }

    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {

            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height

            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                self.profileImageConstrait?.constant = -16
                self.layoutSubviews()
            }, completion: nil)
        }

    }

    @objc func keyboardWillDismiss(_ notification: Notification) {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.profileImageConstrait?.constant = 38
            self.layoutSubviews()
        }, completion: nil)
    }

}

extension ProfileEditView: CodeView {
    func buildViewHierarchy() {
        addSubview(profileImage)
        addSubview(editProfileImageButton)
        addSubview(nameInput)
        addSubview(emailInput)
    }

    func setupConstraints() {
        profileImage.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        profileImageConstrait = profileImage.topAnchor.constraint(
            equalTo: self.layoutMarginsGuide.topAnchor, constant: 38)
        profileImageConstrait?.isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 119).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 113).isActive = true

        editProfileImageButton.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 10).isActive = true
        editProfileImageButton.leadingAnchor.constraint(equalTo: profileImage.leadingAnchor).isActive = true
        editProfileImageButton.trailingAnchor.constraint(equalTo: profileImage.trailingAnchor).isActive = true

        nameInput.topAnchor.constraint(equalTo: editProfileImageButton.bottomAnchor, constant: 20).isActive = true
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

extension ProfileEditView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
