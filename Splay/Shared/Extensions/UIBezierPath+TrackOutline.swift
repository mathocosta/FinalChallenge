//
//  UIBezierPath+TrackOutline.swift
//  Splay
//
//  Created by Martônio Júnior on 20/09/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit

extension UIBezierPath {
    static func createTrackPath(for frame: CGRect) -> CGPath {
        let path = UIBezierPath()
        let halfPi = CGFloat.pi / 2
        let halfWidth = frame.width / 2
        let heightMinusHalfWidth = frame.height - halfWidth
        let higherAnchor = CGPoint(x: halfWidth, y: halfWidth)
        let lowerAnchor = CGPoint(x: halfWidth, y: heightMinusHalfWidth)

//        path.move(to: CGPoint.zero)
//        path.addLine(to: CGPoint(x: frame.maxX, y: frame.maxY))
//        path.addLine(to: CGPoint(x: 0, y: frame.maxY))
//        path.addLine(to: CGPoint(x: frame.maxX, y: 0))
//        path.addLine(to: higherAnchor)
//        path.addLine(to: lowerAnchor)
        path.move(to: CGPoint(x: halfWidth, y: 0))
        path.addArc(withCenter: higherAnchor, radius: halfWidth, startAngle: 3*halfPi,
                    endAngle: CGFloat.pi, clockwise: false)
        path.addLine(to: CGPoint(x: 0, y: lowerAnchor.y))
        path.addArc(withCenter: lowerAnchor, radius: halfWidth, startAngle: CGFloat.pi, endAngle: 0, clockwise: false)
        path.addLine(to: CGPoint(x: frame.width, y: higherAnchor.y))
        path.addArc(withCenter: higherAnchor, radius: halfWidth, startAngle: 0, endAngle: 3*halfPi, clockwise: false)
        path.lineCapStyle = .round
        return path.cgPath
    }
}
