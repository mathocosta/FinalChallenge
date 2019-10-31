//
//  usersPhotoView.swift
//  Splay
//
//  Created by Paulo José on 25/09/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit

class UsersPhotoView: UIView {
    var profileImages: [UIImage] = [] {
        didSet {
            for index in 0..<photoViews.count {
                let view = photoViews[photoViews.count-index-1]
                if index >= profileImages.count {
                    view.isHidden = true
                } else {
                    view.image = profileImages[index]
                }
            }
        }
    }

    lazy var photoViews: [RoundedImageView] = {
        var views: [RoundedImageView] = []
        for _ in 0..<4 {
            let imageView = RoundedImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.image = UIImage(named: "avatar-placeholder")
            imageView.contentMode = .scaleAspectFill
            views.append(imageView)
        }
        return views
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    init(frame: CGRect, images: [UIImage]) {
        profileImages = images
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension UsersPhotoView: CodeView {
    func buildViewHierarchy() {
        for view in photoViews {
            addSubview(view)
        }
    }

    func setupConstraints() {
        for index in 0..<photoViews.count {
            let view = photoViews[index]
            view.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            view.widthAnchor.constraint(equalToConstant: 32).isActive = true
            view.heightAnchor.constraint(equalToConstant: 32).isActive = true
            if index == 0 {
                view.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
            } else {
                view.leftAnchor.constraint(equalTo: photoViews[index-1].rightAnchor, constant: -8).isActive = true
            }
        }
    }

    func setupAdditionalConfiguration() {
    }
}
