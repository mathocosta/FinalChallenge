//
//  UserClous.swift
//  Movinning
//
//  Created by Paulo José on 29/10/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit

class UsersCloud: UIView {
    let team: Team
    let tapAction: (Team) -> Void
    
    init(frame: CGRect, team: Team, action: @escaping (Team) -> Void) {
        self.team = team
        self.tapAction = action
        super.init(frame: frame)
        self.backgroundColor = .red
        
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:))))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleTapGesture(_ sender: UITapGestureRecognizer? = nil) {
        self.tapAction(self.team)
    }
    
}
