//
//  LoadingView.swift
//  Splay
//
//  Created by Paulo José on 17/09/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit

class LoadingView: UIView {
    
    lazy var backdropView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.3)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var activityIndicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        activityIndicatorView.startAnimating()
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LoadingView: CodeView {
    func buildViewHierarchy() {
        addSubview(backdropView)
        addSubview(activityIndicatorView)
    }

    func setupConstraints() {
        backdropView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        backdropView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        backdropView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        backdropView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true

        activityIndicatorView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }

    func setupAdditionalConfiguration() {
    }

}
