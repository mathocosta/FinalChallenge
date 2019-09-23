//
//  TeamPresentationView.swift
//  FinalChallenge
//
//  Created by Matheus Oliveira Costa on 04/09/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit

class TeamDetailsView: UIView {

    let profileDetailsView: ProfileDetailsView = {
        let view = ProfileDetailsView(
            frame: CGRect(x: 0, y: 0, width: 119, height: 130), name: "Ceará", level: 10)
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    lazy var progressBars: ProgressBarsView = {
        let view = ProgressBarsView(frame: .zero, amount: 2)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        backgroundColor = .white

        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - CodeView
extension TeamDetailsView: CodeView {
    func buildViewHierarchy() {
        addSubview(profileDetailsView)
        addSubview(progressBars)
    }

    func setupConstraints() {
        profileDetailsView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        profileDetailsView.topAnchor.constraint(equalTo: self.topAnchor, constant: 200).isActive = true
        profileDetailsView.widthAnchor.constraint(equalToConstant: 119).isActive = true
        profileDetailsView.heightAnchor.constraint(equalToConstant: 130).isActive = true

        progressBars.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        progressBars.topAnchor.constraint(
            equalTo: profileDetailsView.bottomAnchor, constant: 60).isActive = true
        progressBars.heightAnchor.constraint(equalToConstant: BarView.height * 3 + 31 * 2).isActive = true
        progressBars.widthAnchor.constraint(equalToConstant: 195).isActive = true
    }

    func setupAdditionalConfiguration() {
    }

}
