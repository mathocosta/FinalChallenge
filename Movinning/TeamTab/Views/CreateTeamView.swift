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

    lazy var nameInput: Input = {
        let input = Input(frame: .zero, label: NSLocalizedString("Name", comment: ""))
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

    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .backgroundColor
        return scrollView
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
                self.scrollViewTopAnchor?.constant = -16
                self.layoutSubviews()
            }, completion: nil)
        }

    }

    @objc func keyboardWillDismiss(_ notification: Notification) {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.scrollViewTopAnchor?.constant = 38
            self.layoutSubviews()
        }, completion: nil)
    }

}

extension CreateTeamView: CodeView {
    func buildViewHierarchy() {
        scrollView.addSubview(nameInput)
        scrollView.addSubview(descriptionInput)
        scrollView.addSubview(cityInput)
        scrollView.addSubview(neighborhoodInput)

        addSubview(scrollView)
        scrollView.contentSize = CGSize(width: 325, height: 10000)
    }

    func setupConstraints() {
        nameInput.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16).isActive = true
        nameInput.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        nameInput.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        nameInput.heightAnchor.constraint(equalToConstant: Input.height).isActive = true
        nameInput.widthAnchor.constraint(equalToConstant: scrollView.contentSize.width).isActive = true

        descriptionInput.topAnchor.constraint(equalTo: nameInput.bottomAnchor, constant: 32).isActive = true
        descriptionInput.leadingAnchor.constraint(equalTo: nameInput.leadingAnchor).isActive = true
        descriptionInput.trailingAnchor.constraint(equalTo: nameInput.trailingAnchor).isActive = true
        descriptionInput.heightAnchor.constraint(equalToConstant: CustomTextView.height).isActive = true

        cityInput.topAnchor.constraint(equalTo: descriptionInput.bottomAnchor, constant: 47).isActive = true
        cityInput.leadingAnchor.constraint(equalTo: nameInput.leadingAnchor).isActive = true
        cityInput.trailingAnchor.constraint(equalTo: nameInput.trailingAnchor).isActive = true
        cityInput.heightAnchor.constraint(equalToConstant: Input.height).isActive = true

        neighborhoodInput.topAnchor.constraint(equalTo: cityInput.bottomAnchor, constant: 32).isActive = true
        neighborhoodInput.leadingAnchor.constraint(equalTo: nameInput.leadingAnchor).isActive = true
        neighborhoodInput.trailingAnchor.constraint(equalTo: nameInput.trailingAnchor).isActive = true
        neighborhoodInput.heightAnchor.constraint(equalToConstant: Input.height).isActive = true
        
        scrollViewTopAnchor = scrollView.topAnchor.constraint(equalTo: self.topAnchor)
        scrollViewTopAnchor?.isActive = true
        scrollView.leftAnchor.constraint(equalTo: self.layoutMarginsGuide.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.layoutMarginsGuide.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }

    func setupAdditionalConfiguration() {

    }
}
