//
//  RoundedViewProtocol.swift
//  Splay
//
//  Created by Martônio Júnior on 23/09/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit

protocol RoundedViewProtocol {
    func setRounded()
}

extension RoundedViewProtocol where Self: UIView {
    func setRounded() {
        let halfWidth = self.frame.width / 2
        self.layer.cornerRadius = halfWidth
        self.layer.masksToBounds = true
    }
}
