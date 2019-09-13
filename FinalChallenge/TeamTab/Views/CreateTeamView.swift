//
//  CreateTeamView.swift
//  FinalChallenge
//
//  Created by Matheus Oliveira Costa on 13/09/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit

class CreateTeamView: UIView {

    lazy var nameInput: Input = {
        let input = Input(frame: .zero, label: "Nome")
        input.translatesAutoresizingMaskIntoConstraints = false
        input.inputTextField.keyboardType = .alphabet
        return input
    }()

    lazy var descriptionInput: Input = {
        let input = Input(frame: .zero, label: "Descrição")
        input.translatesAutoresizingMaskIntoConstraints = false
        input.inputTextField.keyboardType = .alphabet
        return input
    }()

    lazy var cityInput: Input = {
        let input = Input(frame: .zero, label: "Cidade")
        input.translatesAutoresizingMaskIntoConstraints = false
        input.inputTextField.keyboardType = .alphabet
        return input
    }()

    lazy var neighborhoodInput: Input = {
        let input = Input(frame: .zero, label: "Bairro")
        input.translatesAutoresizingMaskIntoConstraints = false
        input.inputTextField.keyboardType = .alphabet
        return input
    }()

    lazy var formStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [nameInput, descriptionInput, cityInput, neighborhoodInput])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        return stackView
    }()

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        backgroundColor = .white
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension CreateTeamView: CodeView {
    func buildViewHierarchy() {
        addSubview(formStackView)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            nameInput.heightAnchor.constraint(equalToConstant: Input.height),
            descriptionInput.heightAnchor.constraint(equalToConstant: Input.height),
            cityInput.heightAnchor.constraint(equalToConstant: Input.height),
            neighborhoodInput.heightAnchor.constraint(equalToConstant: Input.height),

            formStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            formStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            formStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }

    func setupAdditionalConfiguration() {

    }
}
