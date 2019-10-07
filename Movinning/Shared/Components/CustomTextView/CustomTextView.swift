//
//  CustomTextView.swift
//  Splay
//
//  Created by Paulo José on 26/09/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit

class CustomTextView: UIView {
    
    static var height: CGFloat = 155.0

    var label: String {
        didSet {
            inputLabel.text = label
        }
    }

    lazy var inputLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .sectionTitle
        label.textColor = .textColor
        return label
    }()
    
    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.textColor = .textColor
        textView.font = .input
        textView.backgroundColor = .backgroundColor
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()

    lazy var underline: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    init(frame: CGRect, label: String) {
        self.label = label
        super.init(frame: frame)
        inputLabel.text = label
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CustomTextView: CodeView {
    func buildViewHierarchy() {
        addSubview(inputLabel)
        addSubview(textView)
        addSubview(underline)
    }

    func setupConstraints() {
        inputLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        inputLabel.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        inputLabel.heightAnchor.constraint(equalToConstant: inputLabel.intrinsicContentSize.height).isActive = true
        inputLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true

        textView.topAnchor.constraint(equalTo: inputLabel.bottomAnchor, constant: 8).isActive = true
        textView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        textView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        textView.heightAnchor.constraint(equalToConstant: 108).isActive = true

        underline.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 6).isActive = true
        underline.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        underline.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        underline.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    func setupAdditionalConfiguration() {

    }
}
