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
        completion: @escaping ([CKRecord]?, Error?) -> Void
    ) {
        let operation = CKModifyRecordsOperation(recordsToSave: records, recordIDsToDelete: nil)
        operation.savePolicy = .changedKeys
        operation.modifyRecordsCompletionBlock = { savedRecords, _, error in
            if let error = error as? CKError {

                return completion(nil, error)
            }

            if let savedRecords = savedRecords {
                print("Records salvos: \(savedRecords)")
                return completion(savedRecords, nil)
            }
        }
        database.add(operation)
    }

    func save(_ records: [CKRecord], in database: CKDatabase) -> Promise<[CKRecord]> {
        return Promise { save(records, in: database, completion: $0.resolve) }
    }

}
