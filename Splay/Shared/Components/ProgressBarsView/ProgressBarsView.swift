//
//  ProgressBarsView.swift
//  FinalChallenge
//
//  Created by Paulo José on 06/09/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit

class ProgressBarsView: UIView {

    lazy var firstBar: BarView = {
        let view = BarView(frame: .zero, progress: 0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var secondBar: BarView = {
        let view = BarView(frame: .zero, progress: 0.8)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var thirdBar: BarView = {
        let view = BarView(frame: .zero, progress: 0.2)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension ProgressBarsView: CodeView {
    func buildViewHierarchy() {
        addSubview(firstBar)
        addSubview(secondBar)
        addSubview(thirdBar)
    }

    func setupConstraints() {
        firstBar.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        firstBar.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        firstBar.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        firstBar.heightAnchor.constraint(equalToConstant: BarView.height).isActive = true

        secondBar.topAnchor.constraint(equalTo: firstBar.bottomAnchor, constant: 31).isActive = true
        secondBar.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        secondBar.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        secondBar.heightAnchor.constraint(equalToConstant: BarView.height).isActive = true

        thirdBar.topAnchor.constraint(equalTo: secondBar.bottomAnchor, constant: 31).isActive = true
        thirdBar.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        thirdBar.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        thirdBar.heightAnchor.constraint(equalToConstant: BarView.height).isActive = true
    }

    func setupAdditionalConfiguration() {

    }

}
