//
//  OnboardingViewController.swift
//  Movinning
//
//  Created by Thalia Freitas on 16/10/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController, LoaderView {
    var loadingView: LoadingView = {
        let view = LoadingView()
        return view
    }()

    weak var coordinator: FirstLoginCoordinator?
    var beginningPage: Int?
    var movedToBeginningPage: Bool = false

    let onboardingView: OnboardingView

    lazy var content: [Onboard] = {
        var array = [Onboard]()
        let healthKit: Onboard = Onboard(contentType: .healthKitAuthorization,
                                        assetName: "Artboard",
                                        assetKind: .image)
        let iCloud: Onboard = Onboard(contentType: .cloudKitAuthorization,
                                         assetName: "Artboard2",
                                         assetKind: .image)
        let registration: Onboard = Onboard(contentType: .addMoreInformation,
                                      assetName: "Artboard3",
                                      assetKind: .image)
        array.append(healthKit)
        array.append(iCloud)
        array.append(registration)
        return array
    }()

    init() {
        self.onboardingView = OnboardingView()

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

        switch onboard.contentType {
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

                    let alertController = UIAlertController(title: NSLocalizedString("An Error has occured", comment: ""),
                                                            message: NSLocalizedString("iCloud Auth Error", comment: ""),
                                                            preferredStyle: .alert)
                    let action = UIAlertAction(title: "Ok", style: .default) { (action) in
                        alertController.dismiss(animated: true, completion: nil)
                    }

                    alertController.addAction(action)

                    self.present(alertController, animated: true, completion: nil)
                }
            }
        case .addMoreInformation:
            self.stopLoader()
            coordinator?.showNextScreen()
        }
    }
}
