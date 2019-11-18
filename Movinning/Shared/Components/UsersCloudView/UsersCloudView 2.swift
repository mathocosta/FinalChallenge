//
//  UserCloudView.swift
//  Movinning
//
//  Created by Paulo José on 29/10/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit

class UsersCloudView: UIView {
    let team: Team
    let tapAction: (Team) -> Void

    var numberOfColumns: Int = 0
    var numberOfLines: Int = 0
    var hasLaidOutSubviews: Bool = false

    lazy var profileViews: [RoundedImageView] = {
        guard let members = self.team.members as? Set<User> else { return [] }
        var photoViews: [RoundedImageView] = []
        for member in members {
            let view = RoundedImageView()
            view.translatesAutoresizingMaskIntoConstraints = false
            if let photo = member.photo {
                view.image = UIImage(data: photo)
            } else {
                view.image = UIImage(named: "avatar-placeholder")
            }
            photoViews.append(view)
        }
        return photoViews
    }()

    init(frame: CGRect, team: Team, action: @escaping (Team) -> Void) {
        self.team = team
        self.tapAction = action
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:))))
    }

    override func layoutSubviews() {
        guard !hasLaidOutSubviews else { return }
        setupView()
        hasLaidOutSubviews = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func handleTapGesture(_ sender: UITapGestureRecognizer? = nil) {
        self.tapAction(self.team)
    }

    func processAmountOfColumns(lineAmount: Int) {
        let amountOfUsers = profileViews.count
        var counter = 1
        self.numberOfColumns = counter
        self.numberOfLines = lineAmount
        while amountOfUsers > maxAmountOfUsersFor(lines: self.numberOfLines, columns: counter) {
            counter += 2
            self.numberOfColumns = counter
            self.numberOfLines = amountOfLines()
            if counter == 5 { break }
        }
    }

    func amountOfLines() -> Int {
        let offset = self.getOffset()
        let height = frame.height
        let divisionValue = 3*offset
        let availableSpace = height-16
        let amount = Int(availableSpace / divisionValue)
        return amount
    }

    func maxAmountOfUsersFor(lines: Int, columns: Int) -> Int {
        if columns == 1 {
            return numberOfLines
        } else if columns == 3 {
            return numberOfLines * columns + 1
        }
        return numberOfLines * columns + 4
    }

    func getSize() -> CGFloat {
        let width = frame.width-16
        let value: CGFloat
        if numberOfColumns <= 1 {
            value = min(width, 119)
        } else {
            value = max(width/CGFloat(numberOfColumns), 32)
        }
        return value
    }

    func getOffset() -> CGFloat {
        let offset = self.getSize() / 2
        return offset
    }
}

extension UsersCloudView: CodeView {
    func buildViewHierarchy() {
        for view in self.profileViews {
            addSubview(view)
        }
    }

    func setupConstraints() {
        self.numberOfLines = self.amountOfLines()
        processAmountOfColumns(lineAmount: self.numberOfLines)
        let size = getSize()
        let offset = getOffset()
        let gridLimitIndex = maxAmountOfUsersFor(lines: self.numberOfLines, columns: self.numberOfColumns)-1
        let estimatedHeight = CGFloat(self.numberOfLines) * 2 * size - CGFloat(self.numberOfLines - 1) * size
        let gridHeight = estimatedHeight - CGFloat(2 - (gridLimitIndex % numberOfColumns)/2)
        for index in 0..<profileViews.count {
            let view = profileViews[index]
            let lineIndex = index % numberOfColumns
            view.widthAnchor.constraint(equalToConstant: size).isActive = true
            view.heightAnchor.constraint(equalToConstant: size).isActive = true
            if lineIndex == 0 || index == gridLimitIndex {
                view.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            } else if lineIndex % 2 == 1 {
                view.centerXAnchor.constraint(equalTo: centerXAnchor,
                                              constant: -offset*1.5*CGFloat((lineIndex+1)/2)).isActive = true
            } else {
                view.centerXAnchor.constraint(equalTo: centerXAnchor,
                                              constant: offset*1.5*CGFloat(lineIndex/2)).isActive = true
            }

            if index == 0 {
                if profileViews.count > 1 {
                    view.topAnchor.constraint(equalTo: self.topAnchor,
                                              constant: (frame.height-gridHeight)/2).isActive = true
                } else {
                    view.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
                }
            } else if lineIndex != 0 {
                view.topAnchor.constraint(equalTo: profileViews[index-lineIndex].topAnchor,
                                          constant: offset*CGFloat((lineIndex+1)/2)).isActive = true
            } else {
                view.topAnchor.constraint(equalTo: profileViews[index-numberOfColumns].topAnchor,
                                          constant: size).isActive = true
            }
        }
    }

    func setupAdditionalConfiguration() {

    }
}
