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
        database.save(record) { (_, error) in
            if let error = error {
                return completion(.failure(error))
            }

            return
        }

        completion(.success(record))
    }

    /// Método privado para obter um objeto no CloudKit, esse método serve como base para os métodos mais específicos.
    ///
    /// - Parameters:
    ///   - id: Identificador do objeto a ser buscado
    ///   - entityName: Nome da entidade do objeto
    ///   - database: Database onde o objeto deve estar
    ///   - completion: Callback para ser executado quando a operação finalizar
    private func object(with id: UUID, of entityName: String,
                        in database: CKDatabase, completion: @escaping (ResultHandler<CKRecord>)) {

        let recordID = CKRecord.ID(recordName: "\(entityName)__\(id)")
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

    func create(team: Team, completion: @escaping(ResultHandler<Bool>)) {
        let teamRecord = team.asCKRecord()

        save(teamRecord, in: publicDatabase) { (result) in
            switch result {
            case .success:
                completion(.success(true))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

}

// MARK: - Gerenciamento dos dados dos usuários
extension CloudKitGateway {

    enum UsersDataError: Error {
        case userNotLogged
        case permissionNotGranted
        case notPossibleToSignIn
    }

    private func canUseUserData(completion: @escaping (Bool, Error?) -> Void) {
        container.accountStatus { [weak self] (accountStatus, error) in
            if error != nil {
                completion(false, UsersDataError.userNotLogged)
            } else {
                if case .available = accountStatus {
                    self?.container.requestApplicationPermission(.userDiscoverability) { (status, error) in
                        guard status == .granted, error == nil else {
                            return completion(false, UsersDataError.permissionNotGranted)
                        }

                        completion(true, nil)
                    }
                } else {
                    completion(false, UsersDataError.userNotLogged)
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

    func userIdentity(recordID: CKRecord.ID, completion: @escaping ((CKUserIdentity?) -> Void)) {
        container.discoverUserIdentity(withUserRecordID: recordID) { (userIdentity, error) in
            guard let userIdentity = userIdentity, error == nil else {
                return completion(nil)
            }

            completion(userIdentity)
        }
    }

    func completeRegistration(of userRecord: CKRecord, completion: @escaping (ResultHandler<Bool>)) {
        save(userRecord, in: privateDatabase) { (result) in
            switch result {
            case .success:
                completion(.success(true))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func loginUser(with recordID: CKRecord.ID, completion: @escaping (ResultHandler<[String: Any]>)) {
        // Operation para buscar os dados do usuário
        // Operation para buscar os dados do time
    }

}
