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
        self.achievements = AchievementManager.getAllPossibleAchievements().sorted { a1, a2 in
            return a1.id < a2.id
        }
        self.user = user
        self.sports = Sport.allCases
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.achievementsList = AchievementListView(frame: .zero, direction: .vertical, parentVC: self)
        self.view = achievementsList
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.topItem?.title = NSLocalizedString("Achievements", comment: "")
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

        let achievement = achievmentsWithSport[indexPath.row]

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
            String(describing: AchievementItemViewCell.self), for: indexPath) as? AchievementItemViewCell
        cell?.label.text = NSLocalizedString(achievement.getTitle(), comment: "")
        cell?.iconImageView.image = achievement.image
        return cell ?? UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 64)
    }

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {

        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                    withReuseIdentifier: "Header", for: indexPath) as?
                AchievementHeaderCollectionReusableView else {
                return UICollectionReusableView()
            }
            let sport = sports[indexPath.section]
            let achievementsWithSport = achievements.filter { (achievement) -> Bool in
                return achievement.achievementType == sport
            }

            sectionHeader.backgroundColor = .groupTableViewBackground
            sectionHeader.label.text = achievementsWithSport[indexPath.row].achievementType.localizedName

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
        return CGSize(width: self.view.frame.width/3, height: self.view.frame.width/1.5)
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
