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

extension Team {
    /// Init customizado para quando um objeto precisar ser criado no Core Data local. Só deve ser
    /// chamado quando for necessário criar um novo objeto, caso seja preciso atualizar um já existente,
    /// é preciso obter do contexto e atualizar cada propriedade.
    ///
    /// - Parameters:
    ///   - record: `CKRecord` base para criação do objeto
    ///   - context: Contexto do Core Data para ser usado
    // swiftlint:disable force_cast
    convenience init(record: CKRecord, context: NSManagedObjectContext) {
        self.init(context: context)
        self.id = UUID(uuidString: record["id"] as! String)
        self.name = record["name"] as? String
        self.points = record["points"] as! Int32
    }
    // swiftlint:enable force_cast
}

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
