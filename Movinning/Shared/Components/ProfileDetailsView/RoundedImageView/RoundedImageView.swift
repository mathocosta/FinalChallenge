//
//  RoundedImageView.swift
//  Splay
//
//  Created by Martônio Júnior on 23/09/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit

class RoundedImageView: UIImageView, RoundedViewProtocol {

    override func layoutSubviews() {
        super.layoutSubviews()
        self.setRounded()
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.systemBlue.cgColor
    }

}
