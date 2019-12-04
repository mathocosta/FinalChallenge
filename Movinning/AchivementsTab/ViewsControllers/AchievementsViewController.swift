//
//  AchievementsViewController.swift
//  Movinning
//
//  Created by Thalia Freitas on 20/11/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import Foundation
import UIKit

class AchievementsViewController: UIViewController {

    private var achievementsList: AchievementListView?
    private let user: User
    private var achievements: [Achievement]
    private var sports: [Sport]

    weak var coordinator: AchievementsTabCoordinator?

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(user: User) {
        self.achievements = AchievementManager.getAllPossibleAchievements()
        self.user = user
        self.sports = Array(Sport.allTypes)
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.achievementsList = AchievementListView(frame: .zero, direction: .vertical, parentVC: self)
        self.view = achievementsList

        SessionManager.current.updateRegister(of: user).done(on: .main) { _ in
            self.coordinator?.showAchievementsViewController(for: self.user)
        }.catch(on: .main) { (_) in
            self.presentAlert(with: NSLocalizedString("An Error has occured", comment: ""),
                              message: NSLocalizedString("iCloud Auth Error", comment: ""),
                              completion: {})
        }
        print(UIScreen.main.bounds)

    }

}

extension AchievementsViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return AchievementManager.completedAchievements(of: user).count
        let sport = sports[section]

        let achievementsWithSport = achievements.filter { (achievement) -> Bool in
            return achievement.achievementType == sport
        }

        return achievementsWithSport.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sport = sports[indexPath.section]

        let achievmentsWithSport = achievements.filter { (achievement) -> Bool in
            return achievement.achievementType == sport
        }

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
            String(describing: AchievementItemViewCell.self), for: indexPath) as? AchievementItemViewCell
        cell?.label.text = NSLocalizedString(achievmentsWithSport[indexPath.row].getTitle(), comment: "")
        return cell ?? UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 100, height: 100)
    }

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {

        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath) as? AchievementHeaderCollectionReusableView else {
                return UICollectionReusableView()
            }
            let sport = sports[indexPath.section]
            let achievementsWithSport = achievements.filter { (achievement) -> Bool in
                return achievement.achievementType == sport
            }

            sectionHeader.backgroundColor = .groupTableViewBackground
            sectionHeader.label.text = NSLocalizedString(achievementsWithSport[indexPath.row].getTag(), comment: "")

            return sectionHeader
        default:
            return UICollectionReusableView()
        }
    }
}

extension AchievementsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: AchievementItemViewCell.width, height: AchievementItemViewCell.height)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 32
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sports.count
    }
}
