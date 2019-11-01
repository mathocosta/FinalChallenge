//
//  UserPreferencesView.swift
//  Movinning
//
//  Created by Martônio Júnior on 01/11/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit

class UserPreferencesView: UIView {
    // MARK: - Properties
    lazy var textLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.text = "[Insert Your Tastes Here]"
        label.font = .sectionTitle
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setTitle(NSLocalizedString("Next", comment: ""), for: UIControl.State.normal)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(nextButtonTapped), for: UIControl.Event.touchUpInside)
        button.setTitleColor(.fadedRed, for: UIControl.State.normal)
        button.setTitleColor(.textColor, for: UIControl.State.highlighted)
        button.titleLabel?.font = .action
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .backgroundColor
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    var onNextPage: (() -> Void)?
    @objc func nextButtonTapped(_ sender: UIButton) {
        guard let onNextPage = onNextPage else { return }
        onNextPage()
    }
}

extension UserPreferencesView: CodeView {
    func buildViewHierarchy() {
        addSubview(collectionView)
        addSubview(nextButton)
    }
    
    func setupConstraints() {
        
    }
    
    func setupAdditionalConfiguration() {

    }
}
