//
//  CALayer+CustomShapes.swift
//  Splay
//
//  Created by Martônio Júnior on 20/09/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit

extension CALayer {
    static func createTrackLine(in view: TrackView) {
        let layer = view.layer
        let halfWidth = view.frame.width / 2
        layer.cornerRadius = halfWidth
        layer.sublayers = []
        let path = UIBezierPath.createTrackPath(for: view.frame)

        let trackLayer = CAShapeLayer()
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.strokeColor = UIColor.strokeColor.cgColor
        trackLayer.lineWidth = CGFloat(TrackView.strokeWidth)
        trackLayer.path = path

        let sliceLayer = CAShapeLayer()
        sliceLayer.fillColor = UIColor.clear.cgColor
        sliceLayer.strokeColor = view.trackColor.cgColor
        sliceLayer.strokeEnd = view.progress
        sliceLayer.lineWidth = CGFloat(TrackView.strokeWidth)
        sliceLayer.path = path
        sliceLayer.lineCap = .round

        let pathAnimation = CABasicAnimation(keyPath: "strokeEnd")
        pathAnimation.fromValue = 0
        pathAnimation.toValue = view.progress
        pathAnimation.duration = 2
        pathAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        pathAnimation.autoreverses = false
        pathAnimation.repeatCount = 1

        sliceLayer.add(pathAnimation, forKey: "line")

        layer.addSublayer(trackLayer)
        layer.addSublayer(sliceLayer)
    }

    static func createMovinningActivityIndicator(in view: UIView) {
        let layer = view.layer
        layer.sublayers = []
        let path = UIBezierPath.createLogoPath(for: CGRect(x: 0, y: 0, width: 64, height: 64))

        let logoLayer = CAShapeLayer()
        logoLayer.fillColor = UIColor.clear.cgColor
        logoLayer.strokeColor = UIColor.fadedRed.cgColor
        logoLayer.lineWidth = CGFloat(TrackView.strokeWidth)
        logoLayer.lineJoin = .round
        logoLayer.lineCap = .round
        logoLayer.path = path

        let pathAnimationStart = CABasicAnimation(keyPath: "strokeStart")
        pathAnimationStart.fromValue = 0
        pathAnimationStart.toValue = 1
        pathAnimationStart.duration = 1
        pathAnimationStart.beginTime = CACurrentMediaTime() + 0.3
        pathAnimationStart.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        pathAnimationStart.autoreverses = false
        pathAnimationStart.repeatCount = .infinity

        let pathAnimationEnd = CABasicAnimation(keyPath: "strokeEnd")
        pathAnimationEnd.fromValue = 0
        pathAnimationEnd.toValue = 1
        pathAnimationEnd.duration = 1
        pathAnimationEnd.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        pathAnimationEnd.autoreverses = false
        pathAnimationEnd.repeatCount = .infinity

        logoLayer.add(pathAnimationStart, forKey: "lineStart")
        logoLayer.add(pathAnimationEnd, forKey: "lineEnd")
        layer.addSublayer(logoLayer)
    }
}
