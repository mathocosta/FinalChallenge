//
//  usersPhotoView.swift
//  Splay
//
//  Created by Paulo José on 25/09/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit

class UsersPhotoView: UIView {
    
    lazy var photoView1: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var photoView2: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var photoView3: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var photoView4: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension UsersPhotoView: CodeView {
    func buildViewHierarchy() {
        addSubview(photoView1)
        addSubview(photoView2)
        addSubview(photoView3)
        addSubview(photoView4)
    }

    func setupConstraints() {
        photoView1.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        photoView1.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        photoView1.widthAnchor.constraint(equalToConstant: 32).isActive = true
        photoView1.heightAnchor.constraint(equalToConstant: 32).isActive = true

        photoView2.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        photoView2.leftAnchor.constraint(equalTo: photoView1.rightAnchor, constant: -2).isActive = true
        photoView2.widthAnchor.constraint(equalToConstant: 32).isActive = true
        photoView2.heightAnchor.constraint(equalToConstant: 32).isActive = true

        photoView3.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        photoView3.leftAnchor.constraint(equalTo: photoView2.rightAnchor, constant: -2).isActive = true
        photoView3.widthAnchor.constraint(equalToConstant: 32).isActive = true
        photoView3.heightAnchor.constraint(equalToConstant: 32).isActive = true

        photoView4.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        photoView4.leftAnchor.constraint(equalTo: photoView3.rightAnchor, constant: -2).isActive = true
        photoView4.widthAnchor.constraint(equalToConstant: 32).isActive = true
        photoView4.heightAnchor.constraint(equalToConstant: 32).isActive = true
    }

    func setupAdditionalConfiguration() {
    }
}
