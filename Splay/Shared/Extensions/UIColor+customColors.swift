//
//  UIColor+customColors.swift
//  Splay
//
//  Created by Paulo José on 24/09/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit

extension UIColor {
    
    @nonobjc class var fadedRed: UIColor {
      return UIColor(red: 223.0 / 255.0, green: 58.0 / 255.0, blue: 80.0 / 255.0, alpha: 1.0)
    }

    @nonobjc class var darkSlateBlue: UIColor {
      return UIColor(red: 28.0 / 255.0, green: 33.0 / 255.0, blue: 88.0 / 255.0, alpha: 1.0)
    }

    @nonobjc class var backgroundColor: UIColor {
        return UIColor(named: "backgroundColor") ?? .white
    }

    @nonobjc class var textColor: UIColor {
        return UIColor(named: "textColor") ?? .black
    }

}
