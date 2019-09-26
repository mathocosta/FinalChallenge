//
//  LoadingViewPopTransition.swift
//  Splay
//
//  Created by Paulo José on 17/09/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit

class LoadingViewPopTransition: NSObject, UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewController(forKey: .from) as? LoadingViewController,
            fromViewController.view != nil else { return }

        fromViewController.backdropView.alpha = 1
//        fromViewController.view.backgroundColor = UIColor.black.withAlphaComponent(0)
        fromViewController.activityIndicator.alpha = 1

        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
            fromViewController.backdropView.alpha = 0
//            fromViewController.view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
            fromViewController.activityIndicator.alpha = 0
        }) { (_) in
            transitionContext.completeTransition(true)
        }
    }
}
