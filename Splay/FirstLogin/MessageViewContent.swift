//
//  MessageType.swift
//  FinalChallenge
//
//  Created by Matheus Oliveira Costa on 14/09/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import Foundation

enum MessageViewContent {
    case healthKitAuthorization
    case cloudKitAuthorization
    case addMoreInformation

    var title: String {
        switch self {
        case .healthKitAuthorization:
            return NSLocalizedString("HealthKit title", comment: "")
        case .cloudKitAuthorization:
            return NSLocalizedString("iCloud title", comment: "")
        case .addMoreInformation:
            return NSLocalizedString("Registration title", comment: "")
        }
    }

    var message: String {
        switch self {
        case .healthKitAuthorization:
            return NSLocalizedString("HealthKit authorization", comment: "")
        case .cloudKitAuthorization:
            return NSLocalizedString("iCloud authorization", comment: "")
        case .addMoreInformation:
            return NSLocalizedString("Complete registration", comment: "")
        }
    }
}
