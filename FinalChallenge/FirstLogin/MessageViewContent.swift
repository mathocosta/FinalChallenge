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
            return "Dados de saúde"
        case .cloudKitAuthorization:
            return "Dados da conta iCloud"
        case .addMoreInformation:
            return "Complete seu cadastro!"
        }
    }

    var message: String {
        switch self {
        case .healthKitAuthorization:
            return """
            Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin quis ipsum in dolor maximus
            bibendum. Vivamus sed eros tortor. Nunc eu luctus metus, eu condimentum nunc. Donec ultricies sit amet diam
            sed fermentum.
            """
        case .cloudKitAuthorization:
            return """
            Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin quis ipsum in dolor maximus
            bibendum. Vivamus sed eros tortor. Nunc eu luctus metus, eu condimentum nunc. Donec ultricies sit amet diam
            sed fermentum.
            """
        case .addMoreInformation:
            return """
            Você foi cadastrado automaticamente usando sua conta do iCloud, não precisa fazer mais nada.
            No entanto, pedimos que você coloque mais informações para completar o seu perfil.
            """
        }
    }
}
