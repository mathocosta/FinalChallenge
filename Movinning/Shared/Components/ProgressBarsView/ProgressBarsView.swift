//
//  ProgressBarView.swift
//  Movinning
//
//  Created by Paulo José on 17/10/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit

class ProgressBarsView: UIView {
    var height: CGFloat = BarView.height * 3 + 4

    lazy var bar1: BarView = {
        let view = BarView(frame: .zero, progress: 0.4)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var bar2: BarView = {
        let view = BarView(frame: .zero, progress: 0.2)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var bar3: BarView = {
        let view = BarView(frame: .zero, progress: 0.9)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ProgressBarsView: CodeView {
    func buildViewHierarchy() {
        addSubview(bar1)
        addSubview(bar2)
        addSubview(bar3)
    }

    func setupConstraints() {
        bar1.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        bar1.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        bar1.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        bar1.heightAnchor.constraint(equalToConstant: BarView.height).isActive = true

        bar2.topAnchor.constraint(equalTo: bar1.bottomAnchor, constant: 2).isActive = true
        bar2.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        bar2.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        bar2.heightAnchor.constraint(equalToConstant: BarView.height).isActive = true

        bar3.topAnchor.constraint(equalTo: bar2.bottomAnchor, constant: 2).isActive = true
        bar3.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        bar3.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        bar3.heightAnchor.constraint(equalToConstant: BarView.height).isActive = true
    }

    func setupAdditionalConfiguration() {

    }
}
