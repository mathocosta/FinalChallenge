//
//  AnimationCompletionHandler.swift
//  Splay
//
//  Created by Martônio Júnior on 24/09/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit

public typealias AnimationCompletion = (CAAnimation, Bool) -> Void

public class CAAnimationCompletion: NSObject, CAAnimationDelegate {
    var onStart: AnimationCompletion?
    var onEnd: AnimationCompletion?

    public func animationDidStart(_ anim: CAAnimation) {
        guard let onStart = onStart else { return }
        onStart(anim, true)
    }

    public func animationDidStop(_ anim: CAAnimation, finished: Bool) {
        guard let onEnd = onEnd else { return }
        onEnd(anim, finished)
    }
}

public extension CAAnimation {
    func setOnStart(callback: @escaping AnimationCompletion) {
        if delegate == nil {
            self.delegate = CAAnimationCompletion()
        }

        if let animationCompletion = delegate as? CAAnimationCompletion {
            animationCompletion.onStart = callback
        }
    }

    func setCompletion(callback: @escaping AnimationCompletion) {
        if delegate == nil {
            self.delegate = CAAnimationCompletion()
        }

        if let animationCompletion = delegate as? CAAnimationCompletion {
            animationCompletion.onEnd = callback
        }
    }
}
