//
//  ProgressTracksView.swift
//  Splay
//
//  Created by Martônio Júnior on 21/09/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit

class ProgressTracksView: UIView {
    var tracks: [TrackView] = []
    var amountOfTracks: Int = 0

    init(frame: CGRect, amount: Int) {
        super.init(frame: frame)
        self.amountOfTracks = amount == 0 ? 3 : amount
        setupView()
    }

    func setProgress(index: Int, value: CGFloat) {
        tracks[index].progress = value
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension ProgressTracksView: CodeView {
    func buildViewHierarchy() {
        for _ in 0..<amountOfTracks {
            let view = TrackView(frame: .zero, color: .textColor)
            view.translatesAutoresizingMaskIntoConstraints = false
            tracks.append(view)
            addSubview(view)
        }
    }

    func setupConstraints() {
        for index in 0..<tracks.count {
            let track = tracks[index]
            if index == 0 {
                track.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
                track.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
                track.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
                track.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
            } else {
                let lastTrack = tracks[index-1]
                let strokeBorder = 2
                let distanceBetweenTracks = CGFloat(strokeBorder+TrackView.strokeWidth)
                track.topAnchor.constraint(equalTo: lastTrack.topAnchor,
                                           constant: distanceBetweenTracks).isActive = true
                track.leftAnchor.constraint(equalTo: lastTrack.leftAnchor,
                                            constant: distanceBetweenTracks).isActive = true
                track.rightAnchor.constraint(equalTo: lastTrack.rightAnchor,
                                             constant: -distanceBetweenTracks).isActive = true
                track.bottomAnchor.constraint(equalTo: lastTrack.bottomAnchor,
                                              constant: -distanceBetweenTracks).isActive = true
            }
        }
    }

    func setupAdditionalConfiguration() {

    }

}
