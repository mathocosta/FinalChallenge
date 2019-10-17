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

        for (index, goal) in currentGoals.enumerated() {
            self.updateStatus(index: index, goal: goal)
        }
    }

    func updateStatus(index: Int, goal: Goal) {
        let colors: [UIColor] = [.systemPink, .systemBlue, .systemRed, .systemGreen]
        let bar = profileView.progressBars.bars[index]
        let track = profileView.tracksView.tracks[index]
        let color = colors[index%colors.count]
        var didComplete = false
        GoalsManager.progress(for: user, on: goal) { (amount, required) in
            DispatchQueue.main.async {
                didComplete = amount > required
                guard !didComplete else { return }
                let progress = CGFloat(didComplete ? 1.0 : amount / required)
                let text = didComplete
                ? "Complete" : String.init(format: "%.0f/%.0f", amount, required)
                bar.setGoal(title: goal.title, color: color, progressText: text)
                track.trackColor = color
                track.progress = progress
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
