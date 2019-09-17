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
            let fromView = fromViewController.view else { return }
        
//        let containerView = transitionContext.containerView
        
        fromViewController.backdropView.alpha = 1
        fromViewController.activityIndicator.alpha = 1
    
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
            fromViewController.backdropView.alpha = 0
            fromViewController.activityIndicator.alpha = 0
        }) { (true) in
            transitionContext.completeTransition(true)
        }
    }
}
