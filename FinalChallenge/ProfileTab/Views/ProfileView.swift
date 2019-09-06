//
//  ProfileView.swift
//  FinalChallenge
//
//  Created by Paulo José on 04/09/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit

class ProfileView: UIView {
    
    lazy var profileDetailsView: ProfileDetailsView = {
        let view = ProfileDetailsView(frame: CGRect(x: 0, y: 0, width: 119, height: 130), name: "Paulo", level: 12)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ProfileView: CodeView {
    func buildViewHierarchy() {
        addSubview(profileDetailsView)
    }
    
    func setupConstraints() {
        profileDetailsView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        profileDetailsView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileDetailsView.widthAnchor.constraint(equalToConstant: 119).isActive = true
        profileDetailsView.heightAnchor.constraint(equalToConstant: 130).isActive = true
    }
    
    func setupAdditionalConfiguration() {
        
    }
    
    
}
