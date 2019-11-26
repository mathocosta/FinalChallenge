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

extension LoaderView {
    func startLoader() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
            let window = appDelegate.window else { return }

        loadingView.frame = window.frame
        window.addSubview(loadingView)
//        loadingView.activityIndicatorView.startAnimating()
    }

    func stopLoader() {
        DispatchQueue.main.async {
//            self.loadingView.activityIndicatorView.stopAnimating()
            self.loadingView.removeFromSuperview()
        }
    }

}
