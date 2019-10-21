//
//  AchievmentListView.swift
//  Movinning
//
//  Created by Paulo José on 08/10/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit

class AchievmentListView: UIView {

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .textColor
        label.font = .sectionTitle
        label.text = NSLocalizedString("Achievements", comment: "")
        return label
    }()

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(
            AchievmentItemViewCell.self,
            forCellWithReuseIdentifier: String(describing: AchievmentItemViewCell.self))
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .backgroundColor
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        return collectionView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension AchievmentListView: CodeView {
    func buildViewHierarchy() {
        addSubview(titleLabel)
        addSubview(collectionView)
    }

    func setupConstraints() {
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: self.layoutMarginsGuide.leftAnchor).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true

        collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 14).isActive = true
        collectionView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: 172).isActive = true
    }

    func setupAdditionalConfiguration() {
    }
}

extension AchievmentListView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: AchievmentItemViewCell.self), for: indexPath)
        return cell
    }
}

extension AchievmentListView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: AchievmentItemViewCell.width, height: AchievmentItemViewCell.height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 32
    }
}
