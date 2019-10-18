//
//  CloudKitGateway.swift
//  FinalChallenge
//
//  Created by Matheus Oliveira Costa on 03/09/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import Foundation
import CloudKit
import PromiseKit
import PMKCloudKit

final class CloudKitGateway {

    let container: CKContainer
    let publicDatabase: CKDatabase
    let privateDatabase: CKDatabase

    init(container: CKContainer) {
        self.container = container
        self.publicDatabase = self.container.publicCloudDatabase
        self.privateDatabase = self.container.privateCloudDatabase
    }

    // MARK: - Métodos genéricos

    /// Método para salvar um objeto no CloudKit, esse método serve como base para os métodos mais
    /// especializados para obter `CKRecord` dos tipos específicos.
    ///
    /// - Parameters:
    ///   - records: Objetos para serem salvos
    ///   - database: Database que deve ser salvada
    ///   - completion: Callback para ser executado quando a operação finalizar
    func save(
        _ records: [CKRecord],
        in database: CKDatabase,
        completion: @escaping (ResultHandler<[CKRecord]>)
    ) {
        let operation = CKModifyRecordsOperation(recordsToSave: records, recordIDsToDelete: nil)
        operation.savePolicy = .changedKeys
        operation.modifyRecordsCompletionBlock = { (savedRecords, _, error) in
            if let error = error {
                return completion(.failure(error))
            }

            if let savedRecords = savedRecords {
                print("Records salvos: \(savedRecords)")
                return completion(.success(savedRecords))
            }
        }
        database.add(operation)
    }

    func save(
        _ records: [CKRecord],
        in database: CKDatabase,
        completion: @escaping ([CKRecord]?, Error?) -> Void
    ) {
        let operation = CKModifyRecordsOperation(recordsToSave: records, recordIDsToDelete: nil)
        operation.savePolicy = .changedKeys
        operation.modifyRecordsCompletionBlock = { savedRecords, _, error in
            if let error = error {
                return completion(nil, error)
            }

            if let savedRecords = savedRecords {
                print("Records salvos: \(savedRecords)")
                return completion(savedRecords, nil)
            }
        }
        database.add(operation)
    }

    /// Método para obter uma lista de objetos no CloudKit, esse método serve como base para
    /// os métodos mais específicos.
    ///
    /// - Parameters:
    ///   - entityName: Nome da entidade dos objetos
    ///   - database: Database onde os objetos devem estar
    func objects(of entityName: String, in database: CKDatabase) -> Promise<[CKRecord]> {
        let query = CKQuery(recordType: entityName, predicate: NSPredicate(value: true))
        query.sortDescriptors = [
            NSSortDescriptor(key: "firstName", ascending: true),
            NSSortDescriptor(key: "lastName", ascending: true)
        ]

        return database.perform(query)
    }

}
