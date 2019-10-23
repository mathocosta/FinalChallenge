//
//  MessageView.swift
//  FinalChallenge
//
//  Created by Matheus Oliveira Costa on 14/09/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit

class MessageView: UIView {

    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.bodySmall
        label.textColor = .textColor
        return label
    }()

    let messageTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = false
        textView.textAlignment = .center
        return textView
    }()

    let confirmationButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Confirmar", for: .normal)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(confirmationButtonTapped(_:)), for: .touchUpInside)
        return button
    }()

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        backgroundColor = .backgroundColor
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var onConfirmationButton: (() -> Void)?
    @objc func confirmationButtonTapped(_ sender: UIButton) {
        guard let onConfirmationButton = onConfirmationButton else { return }
        onConfirmationButton()
    }

}

extension MessageView: CodeView {
    func buildViewHierarchy() {
        addSubview(titleLabel)
        addSubview(messageTextView)
        addSubview(confirmationButton)
    }

    func setupConstraints() {
        titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true

        messageTextView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        messageTextView.trailingAnchor.constraint(
            equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        messageTextView.leadingAnchor.constraint(
            equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        messageTextView.heightAnchor.constraint(equalToConstant: 100).isActive = true

        confirmationButton.topAnchor.constraint(equalTo: messageTextView.bottomAnchor, constant: 20).isActive = true
        confirmationButton.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
    }

    func setupAdditionalConfiguration() {
    }
}

extension MessageView: LoaderView {
    var loadingView: LoadingView {
        let view = LoadingView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        return view
    }
}
