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

        let record = CKRecord(recordMetadata: recordMetadata)!

        record["id"] = id?.uuidString
        record["name"] = name
        record["email"] = email
        record["points"] = points

        if let photo = photo, let profileImage = UIImage(data: photo) {
            record["photo"] = ckAsset(of: profileImage)
        }

        if let teamRecord = team?.asCKRecord() {
            record["team"] = CKRecord.Reference(record: teamRecord, action: .none)
        } else {
            record["team"] = nil
        }

        return record
    }
}
