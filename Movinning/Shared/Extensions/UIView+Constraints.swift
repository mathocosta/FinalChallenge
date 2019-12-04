//
//  UIView+Constraints.swift
//  Movinning
//
//  Created by Thalia Freitas on 20/10/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import Foundation
import UIKit

extension UIView {

    func fillSuperview(safeArea: Bool = true) {
        if !safeArea {
            anchor(top: superview?.topAnchor,
                   leading: superview?.leadingAnchor,
                   bottom: superview?.bottomAnchor,
                   trailing: superview?.trailingAnchor)
        } else {
            anchor(top: superview?.safeAreaLayoutGuide.topAnchor,
                   leading:
                superview?.safeAreaLayoutGuide.leadingAnchor,
                   bottom: superview?.bottomAnchor,
                   trailing: superview?.safeAreaLayoutGuide.trailingAnchor)
        }
    }

    func anchor(top: NSLayoutYAxisAnchor?,
                leading: NSLayoutXAxisAnchor?,
                bottom: NSLayoutYAxisAnchor?,
                trailing: NSLayoutXAxisAnchor?,
                padding: UIEdgeInsets = .zero,
                size: CGSize = .zero) {
        translatesAutoresizingMaskIntoConstraints = false

        if let top = top {
            topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
        }
        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive = true
        }
        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing, constant: -padding.right).isActive = true
        }
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }

    func addSubviews(in superview: UIView, views: UIView... ) {
        views.forEach { view in
            superview.addSubview(view)
        }
    }

}
