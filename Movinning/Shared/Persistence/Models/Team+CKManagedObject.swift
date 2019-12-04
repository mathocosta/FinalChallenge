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
    func ckRecord() -> CKRecord {
        let record: CKRecord

        if let recordMetadata = recordMetadata {
            record = CKRecord(recordMetadata: recordMetadata)!
        } else {
            record = CKRecord(recordType: "Teams")
        }

        record["id"] = id?.uuidString
        record["name"] = name
        record["points"] = points
        record["teamDescription"] = teamDescription
        record["city"] = city
        record["neighborhood"] = neighborhood
        record["currentGoalsProgress"] = teamProgress?.value ?? [0, 0, 0]
        record["goalsIndices"] = goals?.value ?? [1, 6, 13]

        if let photo = photo, let profileImage = UIImage(data: photo) {
            record["photo"] = ckAsset(of: profileImage)
        }

        return record
    }
}
