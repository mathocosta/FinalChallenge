//
//  ProfileView.swift
//  FinalChallenge
//
//  Created by Paulo José on 04/09/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit

class ProfileView: UIView {

    var firstBarProgress: Float {
        didSet {
            progressBars.firstBar.progress = CGFloat(firstBarProgress)
        }
    }
    
    var secondBarProgress: Float {
        didSet {
            progressBars.secondBar.progress = CGFloat(secondBarProgress)
        }
    }
    
    var thirdBarProgress: Float {
        didSet {
            progressBars.thirdBar.progress = CGFloat(thirdBarProgress)
        }
    }

    lazy var profileDetailsView: ProfileDetailsView = {
        let view = ProfileDetailsView(
            frame: CGRect(x: 0, y: 0, width: 119, height: 130), name: "Paulo", level: 12)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var progressBars: ProgressBarsView = {
        let view = ProgressBarsView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(frame: CGRect) {
        self.firstBarProgress = 0.0
        self.secondBarProgress = 0.0
        self.thirdBarProgress = 0.0
        super.init(frame: frame)
        backgroundColor = .white
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var onProfileDetails: (() -> Void)?
    @objc func handleProfileDetailsTap(_ sender: UITapGestureRecognizer? = nil) {
        guard let onProfileDetails = onProfileDetails else { return }
        onProfileDetails()
    }

}

extension ProfileView: CodeView {
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
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleProfileDetailsTap(_:)))
        profileDetailsView.addGestureRecognizer(tapGesture)
    }

}
