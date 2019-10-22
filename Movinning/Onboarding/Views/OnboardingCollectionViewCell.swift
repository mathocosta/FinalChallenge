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
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()

    fileprivate lazy var animationView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()

    fileprivate lazy var imageCell: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    lazy var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.adjustsFontForContentSizeCategory = true
        textView.isEditable = false
        textView.isSelectable = false
        textView.textColor = .textColor
        textView.textAlignment = .justified
        textView.font = .bodySmall
        return textView
    }()

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.font = .itemTitle
        label.textColor = .textColor
        label.textAlignment = .center
        return label
    }()

    public var assetOpition: OnboardingAssetsOption? {
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
        } else {
            customContentView.addSubview(imageCell)
        }
        customContentView.addSubview(titleLabel)
        customContentView.addSubview(descriptionTextView)
    }

    private func setupViews() {
        addViews()
        customContentView.fillSuperview()
        if assetOpition == .animation {
            animationView.anchor(top: customContentView.safeAreaLayoutGuide.topAnchor,
                                 leading: customContentView.safeAreaLayoutGuide.leadingAnchor, bottom: nil,
                                 trailing: customContentView.safeAreaLayoutGuide.trailingAnchor, padding:
                UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0), size: .zero)
            animationView.heightAnchor.constraint(equalTo: customContentView.heightAnchor,
                                                  multiplier: 0.6).isActive = true
            titleLabel.anchor(top: animationView.bottomAnchor, leading:
                customContentView.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing:
                customContentView.safeAreaLayoutGuide.trailingAnchor, padding:
                UIEdgeInsets(top: 5, left: 8, bottom: 0, right: 8), size: .zero)
        } else {
            imageCell.anchor(top: customContentView.safeAreaLayoutGuide.topAnchor, leading:
            customContentView.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing:
            customContentView.safeAreaLayoutGuide.trailingAnchor, padding:
                UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0), size: .zero)
            imageCell.heightAnchor.constraint(equalTo: customContentView.heightAnchor, multiplier: 0.6).isActive = true
            titleLabel.anchor(top: imageCell.bottomAnchor, leading:
                customContentView.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing:
                customContentView.safeAreaLayoutGuide.trailingAnchor, padding:
                UIEdgeInsets(top: 5, left: 8, bottom: 0, right: 8), size: .zero)
        }
            descriptionTextView.anchor(top: titleLabel.bottomAnchor, leading:
                customContentView.safeAreaLayoutGuide.leadingAnchor, bottom:
                customContentView.safeAreaLayoutGuide.bottomAnchor, trailing:
                customContentView.safeAreaLayoutGuide.trailingAnchor, padding:
                UIEdgeInsets(top: 5, left: 8, bottom: 0, right: 8), size: .zero)
    }

    func setImage(name: String) {
        self.imageCell.image = UIImage(named: name)
    }
}
