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

        title = NSLocalizedString("Profile", comment: "")
        profileView.onProfileDetails = showProfileEditForm
        profileView.profileDetailsView.name = user.firstName ?? ""
        profileView.profileDetailsView.level = Int(user.points)

        if let imageData = user.photo, let profileImage = UIImage(data: imageData) {
            profileView.profileDetailsView.imageView.image = profileImage
        }
//        PointManager.display = self
    }

    func setProgressBars() {
        let currentGoals = GoalsManager.currentTimedGoals(of: user).sorted { (g1, g2) -> Bool in
            return g1.id < g2.id
        }
        let barsView = profileView.progressBars
        let tracksView = profileView.tracksView
        let colors: [UIColor] = [.systemPink, .systemBlue, .systemRed, .systemGreen]
        for (index, goal) in currentGoals.enumerated() {
            let bar = barsView.bars[index]
            let track = tracksView.tracks[index]
            let color = colors[index%colors.count]
            var didComplete = false
            GoalsManager.progress(for: user, on: goal) { (amount, required) in
                DispatchQueue.main.async {
                    guard !didComplete else { return }
                    didComplete = amount > required
                    let progress = CGFloat(didComplete ? 1.0 : amount / required)
                    bar.goalLabel.text = goal.title
                    bar.progressLabel.text = didComplete
                        ? "Complete" : String.init(format: "%.0f/%.0f", amount, required)
                    bar.goalColor.backgroundColor = color
                    track.trackColor = color
                    bar.progress = progress
                    track.progress = progress
                }
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setProgressBars()
    }

    // MARK: - Actions
    func showProfileEditForm() {
        coordinator?.showProfileEditViewController(for: user)
    }

}

//extension ProfileViewController: PointDisplayUpdater {
//    func didUpdate(newAmount: Int) {
//        self.profileView.profileDetailsView.level = newAmount
//    }
//}
