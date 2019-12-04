//
//  AchievmentListView.swift
//  Movinning
//
//  Created by Paulo José on 08/10/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit

class AchievementListView: UIView {
    var user: User?

    var parentVC: AchievementsViewController

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = parentVC
        collectionView.dataSource = parentVC
        collectionView.register(
            AchievementItemViewCell.self,
            forCellWithReuseIdentifier: String(describing: AchievementItemViewCell.self))
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .backgroundColor
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        collectionView.register(AchievementHeaderCollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header")
        return collectionView
    }()

    public convenience init(frame: CGRect, direction: UICollectionView.ScrollDirection, parentVC: AchievementsViewController) {
        self.init(frame: frame, parentVC: parentVC)
        self.user = UserManager.getLoggedUser()
        self.parentVC = parentVC
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = direction
        }

        setupView()
    }

    init(frame: CGRect, parentVC: AchievementsViewController) {
        self.parentVC = parentVC
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension AchievementListView: CodeView {
    func buildViewHierarchy() {
        addSubview(collectionView)
    }

    func setupConstraints() {
        collectionView.topAnchor.constraint(equalTo: self.topAnchor, constant: 14).isActive = true
        collectionView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }

    func setupAdditionalConfiguration() {
    }
}
