//
//  CustomButtonView.swift
//  Movinning
//
//  Created by Paulo José on 08/10/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit

class CustomButtonView: UIView, CustomView {
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .action
        label.textColor = .white
        label.text = "Action"
        return label
    }()

    init(frame: CGRect, label: String) {
        super.init(frame: frame)
        self.label.text = label
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        setRoundedLayer(color: .fadedRed, radius: self.frame.width, shadowOppacity: 0.5, shadowRadius: 0.5)
    }
}

extension CustomButtonView: CodeView {
    func buildViewHierarchy() {
        addSubview(label)
    }

    func setupConstraints() {
        self.label.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.label.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }

    func setupAdditionalConfiguration() {
    }
}
