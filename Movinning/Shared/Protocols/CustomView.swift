//
//  RoundedView.swift
//  Splay
//
//  Created by Paulo José on 24/09/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit

protocol CustomView {
    
}

extension CustomView where Self: UIView {
    func setRoundedLayer(color: UIColor,
                         radius: CGFloat = 10,
                         shadowOppacity: CGFloat = 0.2,
                         shadowRadius: CGFloat = 3) {

        if let layer = self.layer.sublayers?[0] as? CAShapeLayer {
            layer.removeFromSuperlayer()
        }

        let shadowLayer = CAShapeLayer()
        shadowLayer.masksToBounds = false
        
        shadowLayer.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: radius).cgPath
        shadowLayer.fillColor = color.cgColor    
        shadowLayer.shadowColor = UIColor.black.cgColor
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        shadowLayer.shadowOpacity = 0.2
        shadowLayer.shadowRadius = 3

        self.layer.insertSublayer(shadowLayer, at: 0)
    }
}
