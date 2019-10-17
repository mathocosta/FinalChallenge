//
//  ProgressBarsView.swift
//  FinalChallenge
//
//  Created by Paulo José on 06/09/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit

class LegendProgressView: UIView {

    var bars: [BarView] = []
    var amountOfBars: Int = 0

    init(frame: CGRect, amount: Int) {
        super.init(frame: frame)
        self.amountOfBars = amount
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension LegendProgressView: CodeView {
    func buildViewHierarchy() {
        for _ in 1...amountOfBars {
            let view = BarView(frame: .zero, progress: 0.8)
            view.translatesAutoresizingMaskIntoConstraints = false
            bars.append(view)
            addSubview(view)
        }
    }

    func setupConstraints() {
        for index in 0..<bars.count {
            let bar = bars[index]
            if index == 0 {
                bar.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            } else {
                bar.topAnchor.constraint(equalTo: bars[index-1].bottomAnchor, constant: 12).isActive = true
            }
            bar.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
            bar.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
            bar.heightAnchor.constraint(equalToConstant: BarView.height).isActive = true
        }
    }

    func setupAdditionalConfiguration() {

    }

}
