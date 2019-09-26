//
//  LoadingViewController.swift
//  Splay
//
//  Created by Paulo José on 17/09/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {

    lazy var backdropView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.3)
        return view
    }()

    lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.color = UIColor.textColor
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        view.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.3)
        activityIndicator.startAnimating()

        self.transitioningDelegate = self
    }

    func stopLoader() {
        activityIndicator.stopAnimating()
        dismiss(animated: true, completion: nil)
    }
}

extension LoadingViewController: CodeView {
    func buildViewHierarchy() {
        view.addSubview(backdropView)
        view.addSubview(activityIndicator)
    }

    func setupConstraints() {
        backdropView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        backdropView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        backdropView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        backdropView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true

        activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }

    func setupAdditionalConfiguration() {
    }
}

extension LoadingViewController: UIViewControllerTransitioningDelegate {
    func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        return LoadingViewPushTransition()
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return LoadingViewPopTransition()
    }

}
