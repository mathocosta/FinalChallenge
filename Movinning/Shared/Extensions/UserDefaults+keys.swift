//
//  UserDefaults+keys.swift
//  FinalChallenge
//
//  Created by Matheus Oliveira Costa on 12/09/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import Foundation

extension UserDefaults {

    /// Flag que diz se é a primeira vez que o usuário entra no app
    var userNeedToLogin: Bool {
        get { return bool(forKey: #function) }
        set { set(newValue, forKey: #function) }
    }

    /// Flag que diz se o uso do HealthKit foi permitido
    var isHealthKitAuthorized: Bool {
        get { return bool(forKey: #function) }
        set { set(newValue, forKey: #function) }
    }

    /// Flag que diz se o uso do iCloud e do CloudKit foi autorizado
    var isCloudKitAuthorized: Bool {
        get { return bool(forKey: #function) }
        set { set(newValue, forKey: #function) }
    }

    /// Flag que diz se o cadastro está completo
    var isRegistrationComplete: Bool {
        get { return bool(forKey: #function) }
        set { set(newValue, forKey: #function) }
    }

    /// UUID do `User` logado no device
    var loggedUserUUID: String? {
        get { return string(forKey: #function) }
        set { set(newValue, forKey: #function) }
    }

    /// Último tempo de atualização das metas
    var goalUpdateTime: Date? {
        get { return value(forKey: #function) as? Date }
        set { set(newValue, forKey: #function) }
    }

    /// Último tempo de atualização dos dados do HealthKit
    var healthKitUpdateTime: Date? {
        get { return value(forKey: #function) as? Date }
        set { set(newValue, forKey: #function) }
    }

    /// Flag que diz se o usuário preencheu suas preferências
    var hasChosenUserPreferences: Bool {
        get { return bool(forKey: #function) }
        set { set(newValue, forKey: #function) }
    }

    /// Preferências escolhidas pelo usuário
    var userPreferences: [Sport] {
        get {
            let stringPreferences = value(forKey: #function) as? [String]
            let sportPreferences = stringPreferences?.compactMap(Sport.init)
            return sportPreferences ?? []
        }
        set {
            let stringPreferences = newValue.map{ $0.rawValue }
            set(stringPreferences, forKey: #function)
        }
    }

    /// Preferências escolhidas pelo usuário
    var practiceTime: ExerciseIntensity {
        get {
            if let intValue = value(forKey: #function) as? Int {
                return ExerciseIntensity(rawValue: intValue) ?? .twoAndAHalfHours
            }
            return .twoAndAHalfHours
        }
        set {
            let intValue = newValue.amount()
            set(intValue, forKey: #function)
        }
    }
}
