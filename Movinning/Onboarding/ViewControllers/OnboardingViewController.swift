//
//  OnboardingViewController.swift
//  Movinning
//
//  Created by Thalia Freitas on 16/10/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit
import CloudKit

class OnboardingViewController: UIViewController, LoaderView {
    var loadingView: LoadingView = {
        let view = LoadingView()
        return view
    }()

    weak var coordinator: OnboardingCoordinator?
    var beginningPage: Int?
    var movedToBeginningPage: Bool = false

    let onboardingView: OnboardingView = {
        let view = OnboardingView()
        return view
    }()

    var content: [OnboardingMessageViewContent] = [.healthKitAuthorization, .cloudKitAuthorization, .addMoreInformation]

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = onboardingView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        initialSetup()
        self.navigationController?.navigationBar.isHidden = true
        guard let beginningPage = beginningPage else { return }
        moveTo(page: beginningPage)
    }

    override func viewDidLayoutSubviews() {
        guard let beginningPage = beginningPage, !movedToBeginningPage else { return }
        moveTo(page: beginningPage)
        movedToBeginningPage = true
    }

    private func initialSetup() {
        onboardingView.collectionView.dataSource = self
        onboardingView.collectionView.delegate = self
        onboardingView.collectionView.register(OnboardingCollectionViewCell.self,
                                               forCellWithReuseIdentifier: "OnboardingCollectionViewCell")

        onboardingView.onNextPage = moveToNextPage
        onboardingView.onOnboardingEnd = getStarted
        onboardingView.onSkipOnboarding = skipOnboarding
    }

    func moveToNextPage() {
        let nextPage = onboardingView.currentPage + 1
        if nextPage < content.count {
            actionOnConfirmation(forContentIndex: onboardingView.currentPage)
        }
    }

    func moveTo(page: Int) {
        let indexPath = IndexPath(row: page, section: 0)
        onboardingView.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        onboardingView.currentPage = page
    }

    @objc fileprivate func skipOnboarding() {
        let indexPath = IndexPath(row: content.count-1, section: 0)
        onboardingView.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        onboardingView.currentPage = content.count-1
    }

    @objc fileprivate func getStarted() {
        actionOnConfirmation(forContentIndex: 2)
    }

    private func actionOnConfirmation(forContentIndex index: Int) {
        guard index >= 0, index < content.count else { return }
        let userDefaults = UserDefaults.standard
        let onboard = content[index]
        self.startLoader()

        switch onboard {
        case .healthKitAuthorization:
            self.stopLoader()
            coordinator?.showUserPreferences()
        case .cloudKitAuthorization:
            SessionManager.current.loginUser().done(on: .main) { _ in
                print("Success on login")
                userDefaults.isCloudKitAuthorized = true
                self.stopLoader()
                self.coordinator?.showNextScreen()
            }.catch(on: .main) { (error) in
                var errorMessageKey = "iCloud Auth Error"
                if let ckError = error as? CKError, ckError.code.rawValue == 4 {
                    errorMessageKey = "iCloud Internet Error"
                }

                self.stopLoader()

                self.presentAlert(with: NSLocalizedString("An Error has occured", comment: ""),
                                  message: NSLocalizedString(errorMessageKey, comment: ""),
                                  completion: nil)
            }
        case .addMoreInformation:
            self.stopLoader()
            coordinator?.showNextScreen()
        }
    }
}
