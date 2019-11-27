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

        let arrayModel: [Int] = [5, 7, 9]

        record["id"] = id?.uuidString
        record["name"] = name
        record["points"] = points
        record["teamDescription"] = teamDescription
        record["city"] = city
        record["neighborhood"] = neighborhood
        record["progress"] = teamProgress?.value ?? arrayModel
        record["goals"] = goals?.value ?? arrayModel

        if let photo = photo, let profileImage = UIImage(data: photo) {
            record["photo"] = ckAsset(of: profileImage)
        }

        return record
    }
}
