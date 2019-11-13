//
//  UserPreferencesViewController.swift
//  Movinning
//
//  Created by Martônio Júnior on 01/11/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit

class UserPreferencesViewController: UIViewController, LoaderView {
    // MARK: - Properties
    var loadingView: LoadingView {
        let view = LoadingView()
        return view
    }

    var sports: [Sport] = Array(Sport.allTypes).sorted { $0.localizedName < $1.localizedName }

    lazy var selectedSports: [Sport] = {
        return UserDefaults.standard.userPreferences
    }()

    lazy var preferencesView: UserPreferencesView = {
        let view = UserPreferencesView()
        return view
    }()

    var coordinator: Coordinator?

    // MARK: - Lifecycle
    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view = preferencesView
        preferencesView.onNextPage = confirmUserPreferences
        preferencesView.collectionView.delegate = self
        preferencesView.collectionView.dataSource = self
        preferencesView.collectionView.register(UserPreferencesCollectionViewCell.self,
                                                forCellWithReuseIdentifier: "UserPreferencesCollectionViewCell")
    }

    // MARK: - Actions
    func confirmUserPreferences() {
        let amountOfTime = ExerciseIntensity.intensity(for: preferencesView.timeSegmentedControl.selectedSegmentIndex)
        UserDefaults.standard.hasChosenUserPreferences = true
        UserDefaults.standard.userPreferences = selectedSports
        UserDefaults.standard.practiceTime = amountOfTime
        HealthStoreService.allAllowedSports = selectedSports.count == 0 ? Sport.allTypes : Set(selectedSports)
        HealthStoreService.exerciseIntensity = amountOfTime
        let healthStoreManager = HealthStoreManager()
        healthStoreManager.requestAuthorization { [weak self] (result) in
            switch result {
            case .success(let isAuthorized):
                UserDefaults.standard.isHealthKitAuthorized = isAuthorized
                DispatchQueue.main.async {
                    if let onboardingCoordinator = self?.coordinator as? OnboardingCoordinator {
                        onboardingCoordinator.popUserPreferences()
                    }

                    if let profileTabCoordinator = self?.coordinator as? ProfileTabCoordinator {
                        profileTabCoordinator.popUserPreferences()
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.stopLoader()
                    print(error.localizedDescription)
                }
            }
        }
    }
}
