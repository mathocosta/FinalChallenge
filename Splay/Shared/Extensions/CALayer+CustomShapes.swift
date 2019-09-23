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
        trackLayer.strokeColor = UIColor.gray.cgColor
        trackLayer.lineWidth = CGFloat(TrackView.strokeWidth)
        trackLayer.path = path

        let sliceLayer = CAShapeLayer()
        sliceLayer.fillColor = UIColor.clear.cgColor
        sliceLayer.strokeColor = view.trackColor.cgColor
        sliceLayer.strokeEnd = view.progress
        sliceLayer.lineWidth = CGFloat(TrackView.strokeWidth)
        sliceLayer.path = path

        layer.addSublayer(trackLayer)
        layer.addSublayer(sliceLayer)
    }
}
