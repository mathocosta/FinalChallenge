//
//  CGRect+Center.swift
//  Splay
//
//  Created by Martônio Júnior on 20/09/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit

extension CGRect {
    var center: CGPoint {
        return CGPoint(x: midX, y: midY)
    }
}
