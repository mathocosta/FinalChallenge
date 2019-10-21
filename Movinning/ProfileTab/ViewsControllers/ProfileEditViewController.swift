//
//  ProfileDetailsViewController.swift
//  FinalChallenge
//
//  Created by Paulo José on 06/09/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit

class ProfileEditViewController: UIViewController, LoaderView {

    var loadingView: LoadingView = {
        let view = LoadingView()
        return view
    }()

    // MARK: - Properties
    private let user: User
    private let profileEditView: ProfileEditView

    private var imagePicker: ImagePicker!

    weak var coordinator: ProfileTabCoordinator?

    // MARK: - Lifecycle
    init(user: User) {
        self.user = user
        self.profileEditView = ProfileEditView()
        super.init(nibName: nil, bundle: nil)

        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = profileEditView
        title = self.user.firstName ?? NSLocalizedString("Profile", comment: "")

        profileEditView.firstNameInput.inputTextField.text = user.firstName
        profileEditView.lastNameInput.inputTextField.text = user.lastName
        profileEditView.emailInput.inputTextField.text = user.email
        if let imageData = user.photo, let profileImage = UIImage(data: imageData) {
            profileEditView.editProfileImage.imageView.image = profileImage
        }
        profileEditView.onLogout = logoutUser
        profileEditView.onEditProfileImage = showImagePicker
        profileEditView.onSaveProfile = saveButtonTapped
    }

    // MARK: - Actions
    @objc func saveButtonTapped() {
        let userDefaults = UserDefaults.standard
        if !userDefaults.isRegistrationComplete {
            userDefaults.isRegistrationComplete = true
            UserManager.changeGoals(for: user)
            userDefaults.isFirstLogin = false
        }

        self.startLoader()

        if let profileImage = profileEditView.editProfileImage.imageView.image,
            let imageData = profileImage.pngData() {
            user.photo = imageData
        }

        guard let firstNameText = profileEditView.firstNameInput.inputTextField.text,
            !firstNameText.isEmpty else {
            let alert = UIAlertController.okAlert(
                title: NSLocalizedString("Invalid Name Title", comment: ""),
                message: NSLocalizedString("Invalid Name Message", comment: "")
            )
            self.present(alert, animated: true, completion: nil)
            self.stopLoader()
            return
        }
                
        user.firstName = firstNameText.trimmingCharacters(in: .whitespaces)

        if let lastNameText = profileEditView.lastNameInput.inputTextField.text {
            user.lastName = lastNameText
        }

        guard let emailText = profileEditView.emailInput.inputTextField.text,
            validateEmail(candidate: emailText) else {
            let alert = UIAlertController.okAlert(
                title: NSLocalizedString("Invalid Email Title", comment: ""),
                message: NSLocalizedString("Invalid Email Message", comment: "")
            )
            self.present(alert, animated: true, completion: nil)
            self.stopLoader()
            return
        }

        user.email = emailText

        SessionManager.current.updateRegister(of: user).done(on: .main) { _ in
            self.stopLoader()
            self.coordinator?.showProfileViewController(for: self.user)
        }.catch(on: .main) { (error) in
            print(error.localizedDescription)
        }
    }

    private func logoutUser() {
        UserManager.logout(user: user)
    }

    private func showImagePicker() {
        imagePicker.present(from: self.view)
    }

    private func validateEmail(candidate: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: candidate)
    }
}

// MARK: - ImagePickerDelegate
extension ProfileEditViewController: ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        guard let image = image else { return }
        profileEditView.editProfileImage.imageView.image = image
    }
}
