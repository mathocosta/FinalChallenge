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
        let recordID = CKRecord.ID(recordName: "\(entityName)__\(id!.uuidString)")
        let record = CKRecord(recordType: entityName, recordID: recordID)
        record["id"] = id?.uuidString
        record["name"] = name
        record["email"] = email
        record["points"] = points

        if let photo = photo, let profileImage = UIImage(data: photo) {
            record["photo"] = ckAsset(of: profileImage)
        }

        record["team"] = team?.id?.uuidString

        return record
    }
}
