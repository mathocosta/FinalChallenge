//
//  ProfileView.swift
//  FinalChallenge
//
//  Created by Paulo José on 04/09/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit

class ProgressView: UIView {
    
    private let hasRanking: Bool
    private let rankingAction: () -> Void
    
    var progress: [Float] = []

    var centerView: UIView?


    lazy var progressBars: LegendProgressView = {
        let view = LegendProgressView(frame: .zero, amount: progress.count)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var tracksView: ProgressTracksView = {
        let view = ProgressTracksView(frame: .zero, amount: progress.count)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var rankingButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "ranking"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleRankingTap(_:))))
        return button
    }()

    init(frame: CGRect, centerView: UIView, amount: Int, hasRanking: Bool, rankingAction: @escaping () -> Void) {
        self.centerView = centerView
        self.hasRanking = hasRanking
        self.rankingAction = rankingAction
        progress = Array(repeating: 0, count: amount)
        super.init(frame: frame)
        self.backgroundColor = .backgroundColor
        setupView()
    }

    func setProgress(index: Int, amount: Float) {
        progress[index] = amount
        let cgBarProgress = CGFloat(amount)
        tracksView.setProgress(index: index, value: cgBarProgress)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {

    }
    
    @objc func handleRankingTap(_ sender: UITapGestureRecognizer? = nil) {
        self.rankingAction()
    }

//    var onProfileDetails: (() -> Void)?
//    @objc func handleProfileDetailsTap(_ sender: UITapGestureRecognizer? = nil) {
//        guard let onProfileDetails = onProfileDetails else { return }
//        onProfileDetails()
//    }
}

extension ProgressView: CodeView {
    func buildViewHierarchy() {
        addSubview(tracksView)
        addSubview(centerView!)
        addSubview(progressBars)
        
        if (hasRanking) {
            addSubview(rankingButton)
        }
    }

    func setupConstraints() {
        let screenBounds = UIScreen.main.bounds

        centerView?.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        centerView?.centerYAnchor.constraint(equalTo: tracksView.centerYAnchor).isActive = true
        centerView?.widthAnchor.constraint(equalTo: tracksView.widthAnchor, constant: -16*CGFloat(tracksView.amountOfTracks)-32).isActive = true
        centerView?.heightAnchor.constraint(equalTo: tracksView.heightAnchor, constant: -16*CGFloat(tracksView.amountOfTracks)-32).isActive = true
//        centerView?.widthAnchor.constraint(equalToConstant: 119).isActive = true
//        centerView?.heightAnchor.constraint(equalToConstant: 180).isActive = true

        progressBars.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        progressBars.topAnchor.constraint(
            equalTo: tracksView.bottomAnchor, constant: 24).isActive = true
        progressBars.heightAnchor.constraint(equalToConstant: LegendBarView.height * CGFloat(progressBars.amountOfBars) +
            CGFloat(16 * (progressBars.amountOfBars - 1))).isActive = true
        progressBars.widthAnchor.constraint(equalToConstant: 300).isActive = true

        tracksView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        tracksView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16).isActive = true
        tracksView.widthAnchor.constraint(equalToConstant: screenBounds.width-105).isActive = true
        tracksView.heightAnchor.constraint(equalToConstant: screenBounds.height * 0.55).isActive = true
        
        if (hasRanking) {
            rankingButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
            rankingButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
            rankingButton.widthAnchor.constraint(equalToConstant: 51).isActive = true
            rankingButton.heightAnchor.constraint(equalToConstant: 42).isActive = true
        }
    }
    

    func setupAdditionalConfiguration() {
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleProfileDetailsTap(_:)))
//        centerView?.addGestureRecognizer(tapGesture)
    }

}
