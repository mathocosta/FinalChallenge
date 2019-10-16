//
//  MessageViewController.swift
//  FinalChallenge
//
//  Created by Matheus Oliveira Costa on 14/09/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController, LoaderView {

    var loadingView: LoadingView = {
        let view = LoadingView()
        return view
    }()

    let messageView: MessageView
    let contentType: MessageViewContent

    weak var coordinator: FirstLoginCoordinator?

    init(content: MessageViewContent) {
        self.messageView = MessageView()
        self.contentType = content
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = messageView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        messageView.titleLabel.text = contentType.title
        messageView.messageTextView.text = contentType.message
        messageView.onConfirmationButton = actionOnConfirmation
    }

    private func actionOnConfirmation() {
        let userDefaults = UserDefaults.standard

        self.startLoader()

        switch contentType {
        case .healthKitAuthorization:
            let healthStoreManager = HealthStoreManager()
            healthStoreManager.requestAuthorization { [weak self] (result) in
                switch result {
                case .success(let isAuthorized):
                    userDefaults.isHealthKitAuthorized = isAuthorized
                    DispatchQueue.main.async {
                        self?.stopLoader()
                        self?.coordinator?.showNextScreen()
                    }
                case .failure(let error):
                    self?.stopLoader()
                    print(error.localizedDescription)
                }
            }
        case .cloudKitAuthorization:
//            SessionManager.current.loginUser { (result) in
//                switch result {
//                case .success:
//                    print("Success on login")
//                    userDefaults.isCloudKitAuthorized = true
//                    DispatchQueue.main.async {
//                        self.stopLoader()
//                        self.coordinator?.showNextScreen()
//                    }
//                case .failure(let error):
//                    print(error.localizedDescription)
//                    DispatchQueue.main.async {
//                        self.stopLoader()
//                    }
//                }
//            }

            SessionManager.current.loginUser().done { _ in
                print("Success on login")
                userDefaults.isCloudKitAuthorized = true
                DispatchQueue.main.async {
                    self.stopLoader()
                    self.coordinator?.showNextScreen()
                }
            }.catch { (error) in
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    self.stopLoader()
                }
            }
        case .addMoreInformation:
            self.stopLoader()
            coordinator?.showNextScreen()
        }
    }

}
