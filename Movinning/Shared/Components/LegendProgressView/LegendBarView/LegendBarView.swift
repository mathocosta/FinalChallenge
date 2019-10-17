//
//  BarView.swift
//  FinalChallenge
//
//  Created by Paulo José on 06/09/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit

class LegendBarView: UIView {

    static let height: CGFloat = 20.0

    var goalText: String? {
        didSet {
            guard let goalText = goalText else { return }
            goalLabel.text = goalText
        }
    }

    lazy var goalLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .textColor
        label.font = .itemTitle
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var progressText: String? {
        didSet {
            guard let progressText = progressText else { return }
            progressLabel.text = progressText
        }
    }

    lazy var progressLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .textColor
        label.textAlignment = .right
        label.font = .itemDetail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    var roundedColor: UIColor? {
        didSet {
            guard let roundedColor = roundedColor else { return }
            goalColor.backgroundColor = roundedColor
        }
    }

    lazy var goalColor: RoundedView = {
        let view = RoundedView()
        view.backgroundColor = UIColor.darkGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    init(frame: CGRect, progress: CGFloat = 0.5) {
        super.init(frame: frame)

        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setGoal(title: String, color: UIColor, progressText: String) {
        self.goalText = title
        self.roundedColor = color
        self.progressText = progressText
    }
}

extension LegendBarView: CodeView {
    func buildViewHierarchy() {
        addSubview(goalColor)
        addSubview(goalLabel)
        addSubview(progressLabel)
    }

    func setupConstraints() {
        goalColor.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        goalColor.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        goalColor.widthAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        goalColor.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true

        goalLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        goalLabel.leftAnchor.constraint(equalTo: goalColor.rightAnchor, constant: 8).isActive = true
        goalLabel.rightAnchor.constraint(equalTo: progressLabel.leftAnchor, constant: -8).isActive = true
        goalLabel.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true

        progressLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        progressLabel.widthAnchor.constraint(equalToConstant: 120).isActive = true
        progressLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        progressLabel.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }

    func setupAdditionalConfiguration() {

    }

}
