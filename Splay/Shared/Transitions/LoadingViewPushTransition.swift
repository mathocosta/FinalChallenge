//
//  LoadingViewPushTransition.swift
//  Splay
//
//  Created by Paulo José on 17/09/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit

class LoadingViewPushTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: .to) as? LoadingViewController,
            let toView = toViewController.view else { return }
        
        let containerView = transitionContext.containerView
        
        containerView.addSubview(toView)
        
        toViewController.backdropView.alpha = 0
        toViewController.activityIndicator.alpha = 0
        toView.backgroundColor = UIColor.white.withAlphaComponent(0)
        
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext)) {
            toViewController.backdropView.alpha = 1
            toViewController.activityIndicator.alpha = 1
            toView.backgroundColor = UIColor.white.withAlphaComponent(0)
        }
    }
}
