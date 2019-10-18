//
//  Onboard.swift
//  Movinning
//
//  Created by Thalia Freitas on 18/10/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import Foundation

enum OnboardingAssetsOpition: String {
    case animation = "animation"
    case image = "image"
}

struct Onboard {
    let title : String
    let description: String
    let assetName: String
    let assetKind: OnboardingAssetsOpition
    
    init(title: String, description: String, assetName: String, assetKind: OnboardingAssetsOpition) {
        self.title = title
        self.description = description
        self.assetName = assetName
        self.assetKind = assetKind
    }
}
