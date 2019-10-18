//
//  SessionError.swift
//  Movinning
//
//  Created by Matheus Oliveira Costa on 17/10/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import Foundation

enum SessionError: Error {
    case missingTeamReference
    case missingTeamIdentifier
    case userDontHaveTeam

    var localizedDescription: String {
        switch self {
        case .missingTeamReference:
            return "User record don't have a team reference"
        case .missingTeamIdentifier:
            return "Missing UUID value of property 'id' in team managed object"
        case .userDontHaveTeam:
            return "User don't have team anymore"
        }
    }
}
