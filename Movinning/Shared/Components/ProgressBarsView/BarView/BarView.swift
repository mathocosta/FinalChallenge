//
//  BarView.swift
//  Movinning
//
//  Created by Paulo José on 17/10/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit

class BarView: UIView {

    static var height: CGFloat = 42

    let progress: CGFloat

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .textColor
        label.font = .bodySmall
        label.text = "Meta"
        return label
    }()

    lazy var backgroundBar: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .brownGrey
        return view
    }()

    lazy var progressBar: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .fadedRed
        return view
    }()

    init(frame: CGRect, progress: CGFloat) {
        self.progress = progress
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        progressBar.rightAnchor.constraint(equalTo: backgroundBar.rightAnchor, constant: (self.bounds.width * progress) - self.bounds.width).isActive = true

        backgroundBar.layer.masksToBounds = true
        backgroundBar.layer.cornerRadius = 5
    }

}

extension BarView: CodeView {
    func buildViewHierarchy() {
        addSubview(titleLabel)
        backgroundBar.addSubview(progressBar)
        addSubview(backgroundBar)
    }

    func setupConstraints() {
        progressBar.topAnchor.constraint(equalTo: backgroundBar.topAnchor).isActive = true
        progressBar.leftAnchor.constraint(equalTo: backgroundBar.leftAnchor).isActive = true
        progressBar.bottomAnchor.constraint(equalTo: backgroundBar.bottomAnchor).isActive = true

        titleLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: titleLabel.intrinsicContentSize.height).isActive = true

        backgroundBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5).isActive = true
        backgroundBar.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        backgroundBar.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        backgroundBar.heightAnchor.constraint(equalToConstant: 15).isActive = true
    }

    func setupAdditionalConfiguration() {

    }

}
