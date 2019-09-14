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
        let recordID = CKRecord.ID(recordName: "\(entityName)__\(id!.uuidString)")
        let record = CKRecord(recordType: entityName, recordID: recordID)
        record["id"] = id?.uuidString
        record["name"] = name
        record["points"] = points

        if let photo = photo, let profileImage = UIImage(data: photo) {
            record["photo"] = ckAsset(of: profileImage)
        }

        return record
    }
}
