//
//  CreateTeamView.swift
//  FinalChallenge
//
//  Created by Matheus Oliveira Costa on 13/09/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit

class CreateTeamView: UIView {

    var scrollViewTopAnchor: NSLayoutConstraint?
    var marginViewHeightAnchor: NSLayoutConstraint?

    lazy var nameInput: Input = {
        let input = Input(frame: .zero, label: NSLocalizedString("Name", comment: ""), type: .groupName)
        input.translatesAutoresizingMaskIntoConstraints = false
        input.inputTextField.keyboardType = .alphabet
        return input
    }()

    lazy var descriptionInput: CustomTextView = {
        let input = CustomTextView(frame: .zero, label: NSLocalizedString("Description", comment: ""))
        input.translatesAutoresizingMaskIntoConstraints = false
        input.textView.keyboardType = .alphabet
        return input
    }()

    lazy var detailsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 32
        stackView.axis = .vertical
        return stackView
    }()

    lazy var cityInput: Input = {
        let input = Input(frame: .zero, label: NSLocalizedString("City", comment: ""))
        input.translatesAutoresizingMaskIntoConstraints = false
        input.inputTextField.keyboardType = .alphabet
        return input
    }()

    lazy var neighborhoodInput: Input = {
        let input = Input(frame: .zero, label: NSLocalizedString("Neighborhood", comment: ""))
        input.translatesAutoresizingMaskIntoConstraints = false
        input.inputTextField.keyboardType = .alphabet
        return input
    }()

    lazy var addressStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 32
        stackView.axis = .vertical
        return stackView
    }()

    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .backgroundColor
        return scrollView
    }()

    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 64
        stackView.axis = .vertical
        return stackView
    }()

    lazy var view: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        backgroundColor = .backgroundColor
        setupView()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillDismiss(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {

            let keyboardRectangle = keyboardFrame.cgRectValue

            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                self.marginViewHeightAnchor?.constant = 200
                self.layoutSubviews()
            }, completion: nil)
        }

    }

    @objc func keyboardWillDismiss(_ notification: Notification) {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.marginViewHeightAnchor?.constant = 50
            self.layoutSubviews()
        }, completion: nil)
    }

}

extension CreateTeamView: CodeView {
    func buildViewHierarchy() {
        detailsStackView.addArrangedSubview(nameInput)
        detailsStackView.addArrangedSubview(descriptionInput)

        addressStackView.addArrangedSubview(cityInput)
        addressStackView.addArrangedSubview(neighborhoodInput)

        stackView.addArrangedSubview(detailsStackView)
        stackView.addArrangedSubview(addressStackView)
        stackView.addArrangedSubview(view)

        scrollView.addSubview(stackView)

        addSubview(scrollView)
    }

    func setupConstraints() {
        nameInput.heightAnchor.constraint(equalToConstant: Input.height).isActive = true

        descriptionInput.heightAnchor.constraint(equalToConstant: CustomTextView.height).isActive = true

        cityInput.heightAnchor.constraint(equalToConstant: Input.height).isActive = true

        neighborhoodInput.heightAnchor.constraint(equalToConstant: Input.height).isActive = true

        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 24).isActive = true
        stackView.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: scrollView.rightAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true

        marginViewHeightAnchor = view.heightAnchor.constraint(equalToConstant: 50)
        marginViewHeightAnchor?.isActive = true

        scrollViewTopAnchor = scrollView.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor)
        scrollViewTopAnchor?.isActive = true
        scrollView.leftAnchor.constraint(equalTo: self.layoutMarginsGuide.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.layoutMarginsGuide.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }

    func setupAdditionalConfiguration() {

    }
}
