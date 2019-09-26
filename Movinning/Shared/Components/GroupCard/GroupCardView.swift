//
//  GroupCardView.swift
//  Splay
//
//  Created by Paulo José on 24/09/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit

class GroupCardView: UITableViewCell, CustomView {
    
    var team: Team? {
        didSet {
            groupCardContentView.team = team
        }
    }
    
    static var height = 112 + 8

    lazy var groupCardContentView: GroupCardContentView = {
        let view = GroupCardContentView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        self.selectionStyle = .none
        self.backgroundColor = UIColor.init(white: 0, alpha: 0)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension GroupCardView: CodeView {
    func buildViewHierarchy() {
        self.contentView.addSubview(groupCardContentView)
    }

    func setupConstraints() {
        groupCardContentView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 4).isActive = true
        groupCardContentView.leftAnchor.constraint(equalTo: self.layoutMarginsGuide.leftAnchor).isActive = true
        groupCardContentView.rightAnchor.constraint(equalTo: self.layoutMarginsGuide.rightAnchor).isActive = true
        groupCardContentView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -4).isActive = true
    }

    func setupAdditionalConfiguration() {
    }

}
