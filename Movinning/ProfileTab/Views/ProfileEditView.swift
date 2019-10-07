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

    lazy var editProfileImage: RoundedEditImageView = {
        let imageView = RoundedEditImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    lazy var firstNameInput: Input = {
        let input = Input(frame: .zero, label: NSLocalizedString("First Name", comment: ""))
        input.translatesAutoresizingMaskIntoConstraints = false
        input.inputTextField.keyboardType = .alphabet
        input.inputTextField.delegate = self
        return input
    }()
    
    lazy var lastNameInput: Input = {
        let input = Input(frame: .zero, label: NSLocalizedString("Last Name", comment: ""))
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
        input.inputTextField.autocapitalizationType = .none
        return input
    }()

    lazy var saveButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .actionStyle
        button.setTitle(NSLocalizedString("Save", comment: ""), for: .normal)
        button.backgroundColor = .systemPink
        button.layer.cornerRadius = Input.height / 2
        button.addTarget(self, action: #selector(saveButtonTapped(_:)), for: .touchUpInside)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .backgroundColor
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
//        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {

            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                self.profileImageConstrait?.constant = -32
                self.layoutSubviews()
            }, completion: nil)
//        }

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
        addSubview(editProfileImage)
        addSubview(firstNameInput)
        addSubview(lastNameInput)
        addSubview(emailInput)
        addSubview(saveButton)
    }

    func setupConstraints() {
        editProfileImage.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        profileImageConstrait = editProfileImage.topAnchor.constraint(
            equalTo: self.layoutMarginsGuide.topAnchor, constant: 38)
        profileImageConstrait?.isActive = true
        editProfileImage.widthAnchor.constraint(equalToConstant: 119).isActive = true
        editProfileImage.heightAnchor.constraint(equalToConstant: 119).isActive = true

        firstNameInput.topAnchor.constraint(equalTo: editProfileImage.bottomAnchor, constant: 20).isActive = true
        firstNameInput.leftAnchor.constraint(equalTo: self.layoutMarginsGuide.leftAnchor).isActive = true
        firstNameInput.rightAnchor.constraint(equalTo: self.layoutMarginsGuide.rightAnchor).isActive = true
        firstNameInput.heightAnchor.constraint(equalToConstant: Input.height).isActive = true
        
        lastNameInput.topAnchor.constraint(equalTo: firstNameInput.bottomAnchor, constant: 20).isActive = true
        lastNameInput.leftAnchor.constraint(equalTo: self.layoutMarginsGuide.leftAnchor).isActive = true
        lastNameInput.rightAnchor.constraint(equalTo: self.layoutMarginsGuide.rightAnchor).isActive = true
        lastNameInput.heightAnchor.constraint(equalToConstant: Input.height).isActive = true

        emailInput.topAnchor.constraint(equalTo: lastNameInput.bottomAnchor, constant: 31).isActive = true
        emailInput.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor).isActive = true
        emailInput.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor).isActive = true
        emailInput.heightAnchor.constraint(equalToConstant: Input.height).isActive = true

        saveButton.topAnchor.constraint(equalTo: emailInput.bottomAnchor, constant: 64).isActive = true
        saveButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        saveButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        saveButton.heightAnchor.constraint(equalToConstant: Input.height).isActive = true
    }

    func setupAdditionalConfiguration() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(editProfileImageTapped(_:)))
        editProfileImage.addGestureRecognizer(tapGesture)
        editProfileImage.isUserInteractionEnabled = true
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
