//
//  LoaderView.swift
//  Splay
//
//  Created by Paulo José on 17/09/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit

protocol LoaderView {
    var loadingView: LoadingView { get }
}

extension LoaderView where Self: UIView {
    func startLoader() {
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(loadingView)
        
//        loadingView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
//        loadingView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
//        loadingView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
//        loadingView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true

        loadingView.activityIndicatorView.startAnimating()
    }

    func stopLoader() {
        loadingView.activityIndicatorView.stopAnimating()
        loadingView.removeFromSuperview()
    }

}
