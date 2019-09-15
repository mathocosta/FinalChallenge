//
//  Team+CKManagedObject.swift
//  FinalChallenge
//
//  Created by Matheus Oliveira Costa on 05/09/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit
import CloudKit
import CoreData

extension Team: CKManagedObject {
    func asCKRecord() -> CKRecord {
        guard let recordMetadata = recordMetadata else {
            fatalError("Propriedade 'recordMetadata' não inicializada no user")
        }

        let record = CKRecord(recordMetadata: recordMetadata)!
        
        record["id"] = id?.uuidString
        record["name"] = name
        record["points"] = points

        if let photo = photo, let profileImage = UIImage(data: photo) {
            record["photo"] = ckAsset(of: profileImage)
        }

        return record
    }
}
