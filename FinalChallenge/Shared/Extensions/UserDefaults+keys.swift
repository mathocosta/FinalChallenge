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
    var isFirstLogin: Bool {
        get { return bool(forKey: #function) }
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
}
