//
//  CKRecord+recordMetadata.swift
//  FinalChallenge
//
//  Created by Matheus Oliveira Costa on 14/09/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import Foundation
import CloudKit

extension CKRecord {

    /// Transforma as chaves padrões (metadata) de um CKRecord para Data
    func recordMetadata() -> Data {
        let coder = NSKeyedArchiver(requiringSecureCoding: true)
        encodeSystemFields(with: coder)

        return coder.encodedData
    }

}
