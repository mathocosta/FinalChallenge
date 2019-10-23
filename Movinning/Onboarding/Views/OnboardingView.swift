//
//  OnboardingView.swift
//  Movinning
//
//  Created by Martônio Júnior on 21/10/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit

class OnboardingView: UIView {
    var currentPage: Int {
        get {
            return self.pageControl.currentPage
        }

        set(newValue) {
            self.pageControl.currentPage = newValue
        }
    }

    // MARK: - Properties
    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .clear
        collectionView.alwaysBounceHorizontal = true
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isUserInteractionEnabled = false
        return collectionView
    }()

    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl(frame: .zero)
        pageControl.numberOfPages = 3
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = .fadedRed
        pageControl.pageIndicatorTintColor = .gray
        pageControl.isUserInteractionEnabled = false
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()

    lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setTitle(NSLocalizedString("Next", comment: ""), for: UIControl.State.normal)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(nextButtonTapped), for: UIControl.Event.touchUpInside)
        button.setTitleColor(.fadedRed, for: UIControl.State.normal)
        button.setTitleColor(.textColor, for: UIControl.State.highlighted)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    lazy var buttonsStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [nextButton])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 0
        stack.distribution = .fillEqually
        return stack
    }()

    lazy var getStarted: UIButton = {
        let button = UIButton()
        button.setTitle(NSLocalizedString("Get Started", comment: ""), for: UIControl.State.normal)
        button.setTitleColor(.fadedRed, for: UIControl.State.normal)
        button.addTarget(self, action: #selector(getStartedButtonTapped), for: UIControl.Event.touchUpInside)
        button.setTitleColor(.textColor, for: UIControl.State.highlighted)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
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
    var onSkipOnboarding: (() -> Void)?
    @objc func skipButtonTapped(_ sender: UIButton) {
        guard let onSkipOnboarding = onSkipOnboarding else { return }
        onSkipOnboarding()
    }

    var onNextPage: (() -> Void)?
    @objc func nextButtonTapped(_ sender: UIButton) {
        guard let onNextPage = onNextPage else { return }
        onNextPage()
    }

    var onOnboardingEnd: (() -> Void)?
    @objc func getStartedButtonTapped(_ sender: UIButton) {
        guard let onOnboardingEnd = onOnboardingEnd else { return }
        onOnboardingEnd()
    }

    func addGetStartedButton() {
        nextButton.removeFromSuperview()
        buttonsStackView.addArrangedSubview(getStarted)
    }

    func removeGetStartedButton() {
        getStarted.removeFromSuperview()
        buttonsStackView.addArrangedSubview(nextButton)
    }
}

extension OnboardingView: CodeView {
    func buildViewHierarchy() {
        addSubview(collectionView)
        addSubview(pageControl)
        addSubview(buttonsStackView)
    }

    func setupConstraints() {
        collectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        collectionView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.8).isActive = true

        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.topAnchor.constraint(equalToSystemSpacingBelow: collectionView.safeAreaLayoutGuide.bottomAnchor,
                                         multiplier: 1).isActive = true
        pageControl.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor).isActive = true

        buttonsStackView.topAnchor.constraint(equalTo: pageControl.bottomAnchor).isActive = true
        buttonsStackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        buttonsStackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        buttonsStackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }

    func setupAdditionalConfiguration() {

    }
}
