//
//  OnboardingViewController.swift
//  Movinning
//
//  Created by Thalia Freitas on 16/10/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    lazy var onboardingCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .clear
        collectionView.alwaysBounceHorizontal = true
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl(frame: .zero)
        pageControl.numberOfPages = 3
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = .purple
        pageControl.pageIndicatorTintColor = .gray
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("Next", for: UIControl.State.normal)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(nextDidClicked), for: UIControl.Event.touchUpInside)
        button.setTitleColor(.black, for: UIControl.State.normal)
        button.setTitleColor(UIColor(red:0.12, green:0.27, blue:0.24, alpha:1.0), for: UIControl.State.highlighted)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    fileprivate var skipButton: UIButton = {
        let button = UIButton()
        button.setTitle("Skip", for: UIControl.State.normal)
        button.backgroundColor = .clear
        button.setTitleColor(.black, for: UIControl.State.normal)
        button.addTarget(self, action: #selector(skipDidClicked), for: UIControl.Event.touchUpInside)
        button.setTitleColor(UIColor(red:0.12, green:0.27, blue:0.24, alpha:1.0), for: UIControl.State.highlighted)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var buttonsStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [skipButton, nextButton])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 0
        stack.distribution = .fillEqually
        return stack
    }()
    
    lazy var getStarted: UIButton = {
        let button = UIButton()
        button.setTitle("Get Started", for: UIControl.State.normal)
        button.setTitleColor(.purple, for: UIControl.State.normal)
        button.addTarget(self, action: #selector(getStart), for: UIControl.Event.touchUpInside)
        button.setTitleColor(UIColor(red:0.12, green:0.27, blue:0.24, alpha:1.0), for: UIControl.State.highlighted)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var content : [Onboard] = {
        var array = [Onboard]()
        let healthKit: Onboard = Onboard(title: "Health Kit",
                                        description: "We need to use HealthKit to check how much physical activity you did towards completing goals inside our application. Completing goals allows you to earn points for you and your team.",
                                        assetName: "Artboard",
                                        assetKind: .image)
        let iCloud: Onboard = Onboard(title: "iCloud",
                                         description: "We use your iCloud account data to register you and it gives access to groups, so you can practice together with other people. This also allows you to have the same profile between multiple devices.",
                                         assetName: "Artboard2",
                                         assetKind: .image)
        let registration: Onboard = Onboard(title: "Complete your registration",
                                      description: "Your registration was a success! However, you can also fill your profile with more information, if you're interested.",
                                      assetName: "Artboard3",
                                      assetKind: .image)
        array.append(healthKit)
        array.append(iCloud)
        array.append(registration)
        return array
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        initialSetup()
        self.navigationController?.navigationBar.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    private func initialSetup(){
        addView()
        setUpCollectionViewConstraints()
        setUpPageControlConstraints()
        setUpButtons()
        
        onboardingCollectionView.dataSource = self
        onboardingCollectionView.delegate = self
        onboardingCollectionView.register(OnboardingCollectionViewCell.self, forCellWithReuseIdentifier: "OnboardingCollectionViewCell")
    }
    
    private func addView(){
        view.addSubview(onboardingCollectionView)
        view.addSubview(pageControl)
        view.addSubview(buttonsStackView)
    }
    
    fileprivate func setUpCollectionViewConstraints(){
        onboardingCollectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        onboardingCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        onboardingCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//        onboardingCollectionView.anchor(top: view.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor)
//        onboardingCollectionView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor)
        onboardingCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.8).isActive = true
    }
    
    fileprivate func setUpPageControlConstraints(){
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.topAnchor.constraint(equalToSystemSpacingBelow: onboardingCollectionView.safeAreaLayoutGuide.bottomAnchor, multiplier: 1).isActive = true
        pageControl.centerXAnchor.constraint(equalTo: onboardingCollectionView.centerXAnchor).isActive = true
        
    }
    
    fileprivate func setUpButtons() {
        buttonsStackView.topAnchor.constraint(equalTo: pageControl.bottomAnchor).isActive = true
        buttonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        buttonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        buttonsStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func addGetSButton(){
        
        nextButton.removeFromSuperview()
        buttonsStackView.addArrangedSubview(getStarted)
    }
    func removeGetSButton() {
        getStarted.removeFromSuperview()
        buttonsStackView.addArrangedSubview(nextButton)
    }
    @objc fileprivate func nextDidClicked(){
        if ( pageControl.currentPage + 1 ) < content.count {
            let indexPath = IndexPath(row: pageControl.currentPage+1, section: 0)
            onboardingCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            pageControl.currentPage += pageControl.currentPage 
        }
    }
    
    @objc fileprivate func skipDidClicked(){
        let indexPath = IndexPath(row: content.count-1, section: 0)
        onboardingCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        pageControl.currentPage = content.count-1
        
    }
    
// consertar parar chamar a tela de cadastro
    @objc fileprivate func getStart(){
   
        let tabBarController = UITabBarController()
//        tabBarController.
        UserDefaults.standard.set(true, forKey: "launchedBefore")
        self.navigationController?.pushViewController(tabBarController, animated: true)
        self.navigationItem.hidesBackButton = true
        //present(tabBarController, animated: false, completion: nil)
        
    }
    
}
