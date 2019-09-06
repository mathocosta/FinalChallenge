//
//  BarView.swift
//  FinalChallenge
//
//  Created by Paulo José on 06/09/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit

class BarView: UIView {
    
    static let height: CGFloat = 15.0
    
    let progress: CGFloat
    
    lazy var progressBar: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.darkGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    init(frame: CGRect, progress: CGFloat) {
        self.progress = progress
        super.init(frame: frame)
        
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        progressBar.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -(self.frame.width * progress)).isActive = true
    }
    
}

extension BarView: CodeView {
    func buildViewHierarchy() {
        addSubview(progressBar)
    }
    
    func setupConstraints() {
        progressBar.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        progressBar.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        progressBar.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    func setupAdditionalConfiguration() {
        
    }
    
    
}
