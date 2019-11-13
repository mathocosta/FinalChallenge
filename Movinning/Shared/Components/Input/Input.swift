//
//  Input.swift
//  FinalChallenge
//
//  Created by Paulo José on 06/09/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit

enum InputType {
    case groupName
    case other
}

class Input: UIView {

    let type: InputType

    var label: String {
        didSet {
            inputLabel.text = label
        }
    }

    static let height: CGFloat = 58

    lazy var inputLabel: UILabel = {
        let label = UILabel()
        label.text = self.label
        label.font = .sectionTitle
        label.textColor = .textColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.font = .input
        textField.textColor = .textColor
        textField.returnKeyType = .done
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        return textField
    }()

    lazy var underlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    init(frame: CGRect, label: String, type: InputType = .other) {
        self.label = label
        self.type = type
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension Input: CodeView {
    func buildViewHierarchy() {
        addSubview(inputLabel)
        addSubview(inputTextField)
        addSubview(underlineView)
    }

    func setupConstraints() {
        inputLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        inputLabel.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        inputLabel.widthAnchor.constraint(equalToConstant: inputLabel.intrinsicContentSize.width).isActive = true

        inputTextField.topAnchor.constraint(equalTo: inputLabel.bottomAnchor, constant: 10.0).isActive = true
        inputTextField.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        inputTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true

        underlineView.topAnchor.constraint(equalTo: inputTextField.bottomAnchor, constant: 2).isActive = true
        underlineView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        underlineView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        underlineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }

    func setupAdditionalConfiguration() {

    }
}

extension Input: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textField(
        _ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String
    ) -> Bool {
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return type == .other ? true : count <= 20
    }
}
