//
//  GroupMemberListView.swift
//  Movinning
//
//  Created by Paulo José on 10/10/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit

class GroupMemberListView: UIView {

    var members: [User]? {
        didSet {
            emptyGroupLabel.isHidden = members?.count != 0
        }
    }

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .textColor
        label.font = .sectionTitle
        label.text = "Participantes"
        return label
    }()

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(GroupMemberViewCell.self,
                                forCellWithReuseIdentifier: String(describing: GroupMemberViewCell.self))
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .backgroundColor
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        collectionView.isScrollEnabled = false
        return collectionView
    }()

    lazy var emptyGroupLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .textColor
        label.font = .itemTitle
        label.textAlignment = .center
        label.text = "This group is empty"
        label.isHidden = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension GroupMemberListView: CodeView {
    func buildViewHierarchy() {
        addSubview(titleLabel)
        addSubview(collectionView)
        addSubview(emptyGroupLabel)
    }

    func setupConstraints() {
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: self.layoutMarginsGuide.leftAnchor).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true

        emptyGroupLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        emptyGroupLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -18).isActive = true
        emptyGroupLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        emptyGroupLabel.heightAnchor.constraint(equalToConstant: 200).isActive = true

        collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 14).isActive = true
        collectionView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: 277).isActive = true
    }

    func setupAdditionalConfiguration() {

    }
}

extension GroupMemberListView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return members?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: GroupMemberViewCell.self),
                                                            for: indexPath) as? GroupMemberViewCell else {
            return UICollectionViewCell()
        }

        guard let member = members?[indexPath.row] else {
            return UICollectionViewCell()
        }

        cell.member = member
        return cell
    }
}

extension GroupMemberListView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: GroupMemberViewCell.width, height: GroupMemberViewCell.height)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {

        return 49
    }
}
