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
        title = "Perfil"

        profileEditView.nameInput.inputTextField.text = user.name
        profileEditView.emailInput.inputTextField.text = user.email
        if let imageData = user.photo, let profileImage = UIImage(data: imageData) {
            profileEditView.profileImage.image = profileImage
        }
        profileEditView.onLogout = logoutUser
        profileEditView.onEditProfileImage = showImagePicker

        let saveBarButton = UIBarButtonItem(
            barButtonSystemItem: .save, target: self, action: #selector(saveBarButtonTapped(_:)))

        navigationItem.rightBarButtonItem = saveBarButton
        
    }

    // MARK: - Actions
    @objc func saveBarButtonTapped(_ sender: UIBarButtonItem) {
        let userDefaults = UserDefaults.standard
        if !userDefaults.isRegistrationComplete {
            userDefaults.isRegistrationComplete = true
            UserManager.changeGoals(for: user)
            userDefaults.isFirstLogin = false
        }
        
//        self.coordinator?.showLoadingViewController()
//        let vc = LoadingViewController()
//        vc.modalPresentationStyle = .fullScreen
//        self.present(vc, animated: true, completion: nil)
        
        self.startLoader()
        
        if let profileImage = profileEditView.profileImage.image,
            let imageData = profileImage.pngData() {
            user.photo = imageData
        }

        if let nameText = profileEditView.nameInput.inputTextField.text {
            user.name = nameText
        }

        if let emailText = profileEditView.emailInput.inputTextField.text {
            user.email = emailText
        }

        SessionManager.current.updateRegister(of: user) { [unowned self] result in
            switch result {
            case .success:
                DispatchQueue.main.async {
//                    self.coordinator?.dismissLoadingViewController()
                    self.stopLoader()
                    self.coordinator?.showProfileViewController(for: self.user)
                }
            case .failure(let error):
                DispatchQueue.main.async {
//                    vc.dismiss(animated: true, completion: nil)
                }
                print(error)
            }
        }
    }

    private func logoutUser() {
        UserManager.logout(user: user)
    }

    private func showImagePicker(sender: UIButton) {
        imagePicker.present(from: sender)
    }

}

// MARK: - ImagePickerDelegate
extension ProfileEditViewController: ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        guard let image = image else { return }
        profileEditView.profileImage.image = image
    }
}

