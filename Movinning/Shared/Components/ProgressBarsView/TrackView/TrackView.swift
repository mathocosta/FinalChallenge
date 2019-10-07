//
//  TrackView.swift
//  Splay
//
//  Created by Martônio Júnior on 20/09/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit

class TrackView: UIView {
    static let strokeWidth = 14

    var progress: CGFloat = 0 {
        didSet {
            layoutSubviews()
        }
    }
    var trackColor: UIColor = .textColor

    init(frame: CGRect, color: UIColor) {
        self.trackColor = color
        super.init(frame: frame)
    }

    override func layoutSubviews() {
        CALayer.createTrackLine(in: self)
    }

    override func didMoveToWindow() {
        layoutSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
