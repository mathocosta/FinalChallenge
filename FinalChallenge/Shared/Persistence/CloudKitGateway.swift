//
//  CloudKitGateway.swift
//  FinalChallenge
//
//  Created by Matheus Oliveira Costa on 03/09/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import Foundation
import CloudKit

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

    /// Método privado para salvar um objeto no CloudKit, esse método serve como base para os métodos mais
    /// especializados para obter `CKRecord` dos tipos específicos.
    ///
    /// - Parameters:
    ///   - record: Objeto para ser salvo
    ///   - database: Database que deve ser salvada
    ///   - completion: Callback para ser executado quando a operação finalizar
    private func save(_ record: CKRecord, in database: CKDatabase, completion: @escaping (ResultHandler<CKRecord>)) {
        let operation = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)
        operation.savePolicy = .changedKeys
        operation.modifyRecordsCompletionBlock = { (savedRecords, _, error) in
            guard let savedRecords = savedRecords, error == nil else { return completion(.failure(error!)) }

            if let savedRecord = savedRecords.first {
                print("Records salvos")
                completion(.success(savedRecord))
            }
        }
        database.add(operation)
    }

    /// Método privado para obter um objeto no CloudKit, esse método serve como base para os métodos mais específicos.
    ///
    /// - Parameters:
    ///   - recordId: CKRecord.ID do objeto que deve ser buscado
    ///   - database: Database onde o objeto deve estar
    ///   - completion: Callback para ser executado quando a operação finalizar
    private func object(
        with recordID: CKRecord.ID, in database: CKDatabase, completion: @escaping (ResultHandler<CKRecord>)) {

        database.fetch(withRecordID: recordID) { (record, error) in
            guard let record = record, error == nil else {
                if let error = error {
                    return completion(.failure(error))
                }

                return
            }

            completion(.success(record))
        }
    }

    /// Método privado para obter uma lista de objetos no CloudKit, esse método serve como base para
    /// os métodos mais específicos.
    ///
    /// - Parameters:
    ///   - entityName: Nome da entidade dos objetos
    ///   - database: Database onde os objetos devem estar
    ///   - completion: Callback para ser executado quando a operação finalizar
    private func objects(
        of entityName: String, in database: CKDatabase, completion: @escaping (ResultHandler<[CKRecord]>)) {
        let query = CKQuery(recordType: entityName, predicate: NSPredicate(value: true))
        query.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]

        database.perform(query, inZoneWith: nil) { (records, error) in
            guard let records = records, error == nil else {
                if let error = error {
                    return completion(.failure(error))
                }

                return
            }

            completion(.success(records))
        }
    }

}

// MARK: - Métodos especializados
extension CloudKitGateway {

    func create(team: Team, completion: @escaping(ResultHandler<CKRecord>)) {
        let teamRecord = team.asCKRecord()
        save(teamRecord, in: publicDatabase, completion: completion)
    }

}

// MARK: - Gerenciamento dos dados dos usuários
extension CloudKitGateway {

    private func canUseUserData(completion: @escaping (Bool, Error?) -> Void) {
        container.accountStatus { [weak self] (accountStatus, error) in
            if error != nil {
                completion(false, error)
            } else {
                if case .available = accountStatus {
                    self?.container.requestApplicationPermission(.userDiscoverability) { (status, error) in
                        guard status == .granted, error == nil else {
                            return completion(false, error)
                        }

                        completion(true, nil)
                    }
                } else {
                    completion(false, error)
                }
            }
        }
    }

    func userRecordID(completion: @escaping (ResultHandler<CKRecord.ID>)) {
        canUseUserData { [weak self] (success, error) in
            guard success, error == nil else {
                completion(.failure(error!))
                return
            }

            self?.container.fetchUserRecordID { (userRecordID, error) in
                guard let userRecordID = userRecordID, error == nil else {
                    return completion(.failure(error!))
                }

                completion(.success(userRecordID))
            }
        }
    }

    func userRecord(completion: @escaping (ResultHandler<CKRecord>)) {
        userRecordID { [unowned self] (result) in
            switch result {
            case .success(let userRecordID):
                self.object(with: userRecordID, in: self.privateDatabase, completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func userIdentity(recordID: CKRecord.ID, completion: @escaping ((CKUserIdentity?) -> Void)) {
        container.discoverUserIdentity(withUserRecordID: recordID) { (userIdentity, error) in
            guard let userIdentity = userIdentity, error == nil else {
                return completion(nil)
            }

            completion(userIdentity)
        }
    }

    func userInfo(completion: @escaping (ResultHandler<[String: Any?]>)) {
        let operation = CKUserInformationOperation()
        operation.configuration.container = container

        operation.userInformationCompletionBlock = { userRecord, userIdentity in
            if let userRecord = userRecord {
                let recordMetadata = userRecord.recordMetadata()

                // Checa se uma das keys já foi iniciada
                if userRecord.value(forKey: "name") == nil {
                    var userFullName = ""

                    if let userIdentity = userIdentity, let nameComponents = userIdentity.nameComponents {
                        userFullName = PersonNameComponentsFormatter().string(from: nameComponents)
                    }

                    completion(.success([
                        "name": userFullName,
                        "recordMetadata": recordMetadata
                    ]))
                } else {
                    var photoData = Data()
                    if let photoAsset = userRecord.value(forKey: "photo") as? CKAsset,
                        let photoAssetURL = photoAsset.fileURL {
                        do {
                            photoData = try Data(contentsOf: photoAssetURL)
                        } catch { print(error.localizedDescription) }
                    }

                    completion(.success([
                        "id": userRecord.value(forKey: "id"),
                        "name": userRecord.value(forKey: "name"),
                        "recordMetadata": recordMetadata,
                        "email": userRecord.value(forKey: "email"),
                        "points": userRecord.value(forKey: "points"),
                        "photo": photoData
                    ]))
                }
            }
        }

        container.add(operation)
    }

    func update(userRecord: CKRecord, completion: @escaping (ResultHandler<CKRecord>)) {
        save(userRecord, in: privateDatabase, completion: completion)
    }

}
