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

    lazy var profileImage: RoundedImageView = {
        let imageView = RoundedImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "avatar-placeholder")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    lazy var nameInput: Input = {
        let input = Input(frame: .zero, label: NSLocalizedString("Name", comment: ""))
        input.translatesAutoresizingMaskIntoConstraints = false
        input.inputTextField.keyboardType = .alphabet
        input.inputTextField.delegate = self
        return input
    }()

    lazy var emailInput: Input = {
        let input = Input(frame: .zero, label: NSLocalizedString("Email", comment: ""))
        input.translatesAutoresizingMaskIntoConstraints = false
        input.inputTextField.keyboardType = .emailAddress
        input.inputTextField.delegate = self
        return input
    }()

    lazy var saveButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(NSLocalizedString("Save", comment: ""), for: .normal)
        button.backgroundColor = .systemPink
        button.layer.cornerRadius = Input.height / 2
        button.addTarget(self, action: #selector(saveButtonTapped(_:)), for: .touchUpInside)
        return button
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

    var onSaveProfile: (() -> Void)?
    @objc func saveButtonTapped(_ sender: UIButton) {
        guard let onSaveProfile = onSaveProfile else { return }
        onSaveProfile()
    }

    var onLogout: (() -> Void)?
    @objc func logoutButtonTapped(_ sender: UIButton) {
        guard let onLogout = onLogout else { return }
        onLogout()
    }

    var onEditProfileImage: (() -> Void)?
    @objc func editProfileImageTapped(_ sender: UITapGestureRecognizer? = nil) {
        guard let onEditProfileImage = onEditProfileImage else { return }
        onEditProfileImage()
    }

    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {

            let keyboardRectangle = keyboardFrame.cgRectValue

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
        addSubview(nameInput)
        addSubview(emailInput)
        addSubview(saveButton)
    }

    func setupConstraints() {
        profileImage.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        profileImageConstrait = profileImage.topAnchor.constraint(
            equalTo: self.layoutMarginsGuide.topAnchor, constant: 38)
        profileImageConstrait?.isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 119).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 119).isActive = true

        nameInput.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 20).isActive = true
        nameInput.leftAnchor.constraint(equalTo: self.layoutMarginsGuide.leftAnchor).isActive = true
        nameInput.rightAnchor.constraint(equalTo: self.layoutMarginsGuide.rightAnchor).isActive = true
        nameInput.heightAnchor.constraint(equalToConstant: Input.height).isActive = true

        emailInput.topAnchor.constraint(equalTo: nameInput.bottomAnchor, constant: 31).isActive = true
        emailInput.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor).isActive = true
        emailInput.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor).isActive = true
        emailInput.heightAnchor.constraint(equalToConstant: Input.height).isActive = true
        
        saveButton.topAnchor.constraint(equalTo: emailInput.bottomAnchor, constant: 31).isActive = true
        saveButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        saveButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        saveButton.heightAnchor.constraint(equalToConstant: Input.height).isActive = true
    }

    func setupAdditionalConfiguration() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(editProfileImageTapped(_:)))
        profileImage.addGestureRecognizer(tapGesture)
        profileImage.isUserInteractionEnabled = true
    }

}

extension ProfileEditView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension ProfileEditView: LoaderView {
    var loadingView: LoadingView {
        let view = LoadingView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        return view
    }
}
