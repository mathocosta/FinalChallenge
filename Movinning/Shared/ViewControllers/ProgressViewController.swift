//
//  ProfileViewController.swift
//  FinalChallenge
//
//  Created by Paulo José on 04/09/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit
import HealthKit

class ProgressViewController: UIViewController {

    private let user: User
    private let profileView: ProgressView

    weak var coordinator: ProfileTabCoordinator?

    let centerView: UIView

    init(user: User, centerView: UIView) {
        self.user = user
        self.centerView = centerView
        self.profileView = ProgressView(frame: .zero, centerView: centerView)

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
        let colors: [UIColor] = [.trackRed, .trackBlue, .trackOrange]
        let bar = profileView.progressBars.bars[index]
        let track = profileView.tracksView.tracks[index]
        let color = colors[index%colors.count]
        var didComplete = false
        GoalsManager.progress(for: user, on: goal) { (amount, required) in
            DispatchQueue.main.async {
                guard !didComplete else { return }
                didComplete = amount > required
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
