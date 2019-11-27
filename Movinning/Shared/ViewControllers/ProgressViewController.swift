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
    private let progressView: ProgressView
    private let amount: Int
    private let hasRanking: Bool

    weak var coordinator: Coordinator?

    let centerView: UIView

    init(user: User, centerView: UIView, amount: Int, hasRanking: Bool, rankingAction: @escaping (() -> Void)) {
        self.user = user
        self.centerView = centerView
        self.amount = amount
        self.hasRanking = hasRanking
        self.progressView = ProgressView(frame: .zero,
                                         centerView: centerView,
                                         amount: amount,
                                         hasRanking: hasRanking,
                                         rankingAction: rankingAction)

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = progressView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = centerView is UsersCloudView ? user.team?.name : NSLocalizedString("Profile", comment: "")
    }

    func setProgressBars() {
        let goals = centerView is UsersCloudView ? GoalsManager.teamGoals(for: user)
            : GoalsManager.currentTimedGoals(of: user)
        let currentGoals = goals.sorted { return $0.id < $1.id }

        for (index, goal) in currentGoals.enumerated() {
            self.updateProgress(index: index, goal: goal)
        }
    }

    func updateProgress(index: Int, goal: Goal) {
        guard self.amount > 0 else { return }
        if centerView is UsersCloudView, let team = user.team {
            guard let teamProgress = team.teamProgress else { return }
            self.updateStatus(index: index, goal: goal, amount: Double(teamProgress.value[index]), required: Double(goal.requiredAmount()))
        } else if centerView is ProfileDetailsView {
            GoalsManager.progress(for: user, on: goal) { (amount, required) in
                self.updateStatus(index: index, goal: goal, amount: amount, required: required)
            }
        }
    }

    func updateStatus(index: Int, goal: Goal, amount: Double, required: Double) {
        DispatchQueue.main.async {
            let colors: [UIColor] = [.trackRed, .trackBlue, .trackOrange]
            let bar = self.progressView.progressBars.bars[index]
            let track = self.progressView.tracksView.tracks[index]
            let color = colors[index%colors.count]
            var didComplete = false
            didComplete = amount > required
            let progress = CGFloat(didComplete ? 1.0 : amount / required)
            let text = didComplete
            ? "Complete" : String.init(format: "%.0f/%.0f", amount, required)
            bar.setGoal(title: goal.title, color: color, progressText: text)
            track.trackColor = color
            track.progress = progress
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setProgressBars()
    }

    override func viewDidAppear(_ animated: Bool) {
        // Isso convoca usuários a atualizarem suas preferências se não tiverem sido feitas ainda.
        let defaults = UserDefaults.standard
        if let profileCoordinator = coordinator as? ProfileTabCoordinator, !defaults.hasChosenUserPreferences {
            let alertController = UIAlertController(
                title: NSLocalizedString("Choose your preferences", comment: ""),
                message: NSLocalizedString("Choose your preferences message", comment: ""),
                preferredStyle: .alert
            )

            let confirmAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default) { _ in
                UserDefaults.standard.hasChosenUserPreferences = true
                profileCoordinator.showProfileEditViewController(for: self.user)
                profileCoordinator.showUserPreferences()
            }

            let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel) { _ in
                UserDefaults.standard.hasChosenUserPreferences = true
                alertController.dismiss(animated: true) {
                    defaults.hasChosenUserPreferences = true
                }
            }

            alertController.addAction(confirmAction)
            alertController.addAction(cancelAction)
            present(alertController, animated: true, completion: nil)
        }
    }

}

extension ProgressViewController: PointDisplayUpdater {
    func didUpdate(newAmount: Int) {
        DispatchQueue.main.async {
            guard let profileView = self.centerView as? ProfileDetailsView else { return }
            profileView.level = newAmount
        }
    }
}
