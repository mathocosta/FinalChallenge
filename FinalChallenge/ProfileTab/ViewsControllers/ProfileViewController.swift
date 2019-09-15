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

    private let user: User
    private let profileView: ProfileView

    weak var coordinator: ProfileTabCoordinator?

    init(user: User) {
        self.user = user
        self.profileView = ProfileView()

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = profileView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Perfil"
        profileView.onProfileDetails = showProfileEditForm
        profileView.profileDetailsView.name = user.name ?? ""

        if let imageData = user.photo, let profileImage = UIImage(data: imageData) {
            profileView.profileDetailsView.imageView.image = profileImage
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchHealthStoreData()
    }

//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        let userDefaults = UserDefaults.standard
//        if userDefaults.isFirstLogin {
//            showCompleteRegistrationAlert()
//        }
//    }

    // MARK: - Actions
    func showProfileEditForm() {
        coordinator?.showProfileEditViewController(for: user)
    }

//    func showCompleteRegistrationAlert() {
//        let alertController = UIAlertController(
//            title: "Complete seu cadastro!",
//            message: "Você foi cadastrado automaticamente usando sua conta do iCloud, não precisa fazer mais nada.
    //No entanto, pedimos que você coloque mais informações para completar o seu perfil.",
//            preferredStyle: .alert
//        )
//
//        alertController.addAction(UIAlertAction(title: "Ok", style: .default) { [weak self] _ in
//            self?.showProfileEditForm()
//        })
//        alertController.addAction(UIAlertAction(title: "Agora não", style: .cancel, handler: nil))
//
//        present(alertController, animated: true, completion: {
//            UserDefaults.standard.isFirstLogin = false
//        })
//    }

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
