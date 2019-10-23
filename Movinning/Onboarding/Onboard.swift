//
//  Onboard.swift
//  Movinning
//
//  Created by Thalia Freitas on 18/10/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import Foundation

enum OnboardingAssetsOption: String {
    case animation
    case image
}

struct Onboard {
    let contentType: MessageViewContent
    var title: String {
        get {
            return contentType.title
        }
    }
    var description: String {
        get {
            return contentType.message
        }
    }
    let assetName: String
    let assetKind: OnboardingAssetsOption

    init(contentType: MessageViewContent, assetName: String, assetKind: OnboardingAssetsOption) {
        self.contentType = contentType
        self.assetName = assetName
        self.assetKind = assetKind
    }
}
