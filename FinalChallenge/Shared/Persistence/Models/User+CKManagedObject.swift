//
//  User+CKManagedObject.swift
//  FinalChallenge
//
//  Created by Matheus Oliveira Costa on 04/09/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit
import CloudKit
import CoreData

extension User: CKManagedObject {
    func asCKRecord() -> CKRecord {
        guard let recordMetadata = recordMetadata else {
            fatalError("Propriedade 'recordMetadata' não inicializada no user")
        }

        do {
            let coder = try NSKeyedUnarchiver(forReadingFrom: recordMetadata)
            coder.requiresSecureCoding = true
            let record = CKRecord(coder: coder)!
            coder.finishDecoding()

            record["id"] = id?.uuidString
            record["name"] = name
            record["email"] = email
            record["points"] = points

            if let photo = photo, let profileImage = UIImage(data: photo) {
                record["photo"] = ckAsset(of: profileImage)
            }

            record["team"] = team?.id?.uuidString

            return record
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
