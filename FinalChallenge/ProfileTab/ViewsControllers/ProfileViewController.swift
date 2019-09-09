//
//  ProfileViewController.swift
//  FinalChallenge
//
//  Created by Paulo José on 04/09/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit
import HealthKit

class ProfileViewController: UIViewController {

    weak var coordinator: ProfileTabCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()

        let profileView = ProfileView()
        profileView.coordinator = coordinator

        self.view = profileView
        fetchHealthStoreData()
    }

    // TODO: Refatorar daqui pra baixo, foi feito rápido para colocar no testflight :P
    func fetchHealthStoreData() {
        let healthStoreManager = HealthStoreManager()

        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: Date())
        let startDate = calendar.date(from: components)!
        healthStoreManager.quantitySum(from: startDate, of: .stepCount) { [weak self] (result) in
            switch result {
            case .success(let statistics):
                if let quantity = statistics.sumQuantity() {
                    let numberOfSteps = quantity.doubleValue(for: HKUnit.count())
                    let healthData = [
                        "stepCount": numberOfSteps
                    ]

                    DispatchQueue.main.async {
                        self?.updateView(with: healthData)
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    func updateView(with healthData: [String: Double]) {
        guard let stepCountValue = healthData["stepCount"] else { return }
        if let profileView = view as? ProfileView {
            profileView.firstBarProgress = Float(stepCountValue / 8000)
        }
    }

}
