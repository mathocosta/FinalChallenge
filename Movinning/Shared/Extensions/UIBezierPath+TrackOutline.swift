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

        path.move(to: CGPoint(x: halfWidth, y: 0))
        path.addArc(withCenter: higherAnchor, radius: halfWidth, startAngle: 3*halfPi,
                    endAngle: CGFloat.pi, clockwise: false)
        path.addLine(to: CGPoint(x: 0, y: lowerAnchor.y))
        path.addArc(withCenter: lowerAnchor, radius: halfWidth, startAngle: CGFloat.pi, endAngle: 0, clockwise: false)
        path.addLine(to: CGPoint(x: frame.width, y: higherAnchor.y))
        path.addArc(withCenter: higherAnchor, radius: halfWidth, startAngle: 0, endAngle: 3*halfPi, clockwise: false)
        return path.cgPath
    }

    static func createLogoPath(for frame: CGRect) -> CGPath {
        let path = UIBezierPath()
        let halfHeight = frame.height / 2
        let halfWidth = frame.width / 2
        let lowerY = frame.height * 0.8
        let lowerAnchor = CGPoint(x: halfWidth*0.75, y: halfHeight)
        let higherAnchor = CGPoint(x: halfWidth*1.4, y: halfHeight*0.4)

        path.move(to: CGPoint(x: -halfWidth*10, y: lowerY))
        path.addLine(to: CGPoint(x: halfWidth*0.5, y: lowerY))
        path.addLine(to: lowerAnchor)
        path.addLine(to: CGPoint(x: halfWidth, y: lowerY))
        path.addLine(to: higherAnchor)
        path.addLine(to: CGPoint(x: halfWidth*1.8, y: lowerY))
        path.addLine(to: CGPoint(x: halfWidth*10, y: lowerY))

        return path.cgPath
    }
}
