//
//  OnboardingCollectionViewCell.swift
//  Movinning
//
//  Created by Thalia Freitas on 18/10/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit

class OnboardingCollectionViewCell: UICollectionViewCell {
    
    fileprivate var customContentView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    fileprivate lazy var animationView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    fileprivate lazy var imageCell: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "description"
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Title"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    
    public var assetOpition: OnboardingAssetsOpition? {
        didSet {
           setupViews()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func addViews() {
        addSubview(customContentView)
        if assetOpition == .animation {
            customContentView.addSubview(animationView)
        }else{
            customContentView.addSubview(imageCell)
        }
        
        customContentView.addSubview(titleLabel)
        customContentView.addSubview(descriptionLabel)
        
    }
    
    private func setupViews() {
        addViews()
        
//        customContentView.fillSuperview()
        
        if assetOpition == .animation {
            animationView.topAnchor.constraint(equalTo: customContentView.topAnchor, constant: 20).isActive = true
            animationView.leadingAnchor.constraint(equalTo: customContentView.leadingAnchor, constant: 0).isActive = true
            animationView.trailingAnchor.constraint(equalTo: customContentView.trailingAnchor, constant: 0).isActive = true
            animationView.heightAnchor.constraint(equalTo: customContentView.heightAnchor, multiplier: 0.7).isActive = true
            titleLabel.topAnchor.constraint(equalTo: animationView.topAnchor, constant: 5).isActive = true
            titleLabel.leadingAnchor.constraint(equalTo: customContentView.leadingAnchor, constant: 8).isActive = true
            titleLabel.trailingAnchor.constraint(equalTo: customContentView.trailingAnchor, constant: 8).isActive = true
            
            

        }else{
            
            
            imageCell.topAnchor.constraint(equalTo: customContentView.topAnchor, constant: 20).isActive = true
            imageCell.leadingAnchor.constraint(equalTo: customContentView.leadingAnchor, constant: 0).isActive = true
            imageCell.trailingAnchor.constraint(equalTo: customContentView.trailingAnchor, constant: 0).isActive = true
            

            imageCell.heightAnchor.constraint(equalTo: customContentView.heightAnchor, multiplier: 0.7).isActive = true
            
            
            titleLabel.topAnchor.constraint(equalTo: animationView.topAnchor, constant: 5).isActive = true
            titleLabel.leadingAnchor.constraint(equalTo: customContentView.leadingAnchor, constant: 8).isActive = true
            titleLabel.trailingAnchor.constraint(equalTo: customContentView.trailingAnchor, constant: 8).isActive = true
        }
        
        descriptionLabel.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: 5).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: customContentView.leadingAnchor, constant: 8).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: customContentView.trailingAnchor, constant: 8).isActive = true
        
        
    }
    
//    func addAnimation(aniamtionName: String){
//        let animationView = LOTAnimationView(name: aniamtionName, bundle: Bundle.main)
//        self.animationView.addSubview(animationView)
//        animationView.fillSuperview(safeArea: true)
//        animationView.play()
//    }
    func setImage(name: String) {
        self.imageCell.image = UIImage(named: name)
    }
}
