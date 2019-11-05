//
//  UserPreferencesViewController.swift
//  Movinning
//
//  Created by Martônio Júnior on 01/11/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit

class UserPreferencesViewController: UIViewController {
    var sports: [Sport] = Array(Sport.allTypes).sorted { (s1, s2) -> Bool in
        return s1.name() < s2.name()
    }
    var selectedSports: [Sport] = []

    // MARK: - Properties
    lazy var preferencesView: UserPreferencesView = {
        let view = UserPreferencesView()
        return view
    }()

    var coordinator: UserPreferencesCoordinator?

    // MARK: - Lifecycle

    init() {
        super.init(nibName: nil, bundle: nil)
        guard let preferredSports = UserDefaults.standard.userPreferences else { return }
        selectedSports = preferredSports
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view = preferencesView
        preferencesView.onNextPage = confirmUserPreferences
        preferencesView.tableView.delegate = self
        preferencesView.tableView.dataSource = self
        preferencesView.tableView.register(UserPreferencesTableViewCell.self,
                                                forCellReuseIdentifier: "UserPreferencesCollectionViewCell")
    }

    // MARK: - Actions
    func confirmUserPreferences() {
        let amountOfTime = ExerciseIntensity.intensity(for: preferencesView.timeSegmentedControl.selectedSegmentIndex)
        UserDefaults.standard.chosenUserPreferences = true
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
                    self?.coordinator?.redirectToNextScreen()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    print(error.localizedDescription)
                }
            }
        }
    }
}
