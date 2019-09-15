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

// MARK: - Gerenciamento dos dados dos usuários
extension CloudKitGateway {


    /// Esse método faz toda a checagem necessária para usar os dados do usuário
    /// logado no device.
    /// FIXME: Ainda não tem tratamento de erros para caso o usuário não dê acesso para usar a conta do iCloud.
    /// - Parameter completion: Callback executado quando o processo é terminado e com os possíveis erros
    func canUseUserData(completion: @escaping (Bool, Error?) -> Void) {
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

    /// Esse método obtém os dados do usuário logado na conta do iCloud do dispositivo.
    /// Como pode ser que ele nunca tenha usado o app, é feito um processo de inicialização
    /// do `CKRecord` antes colocando o nome que está na conta do iCloud. Mas caso já tenha usado
    /// e o record já exista na database, é apenas retornado com os dados antigos.
    /// - Parameter completion: Callback executado quando os dados do usuário são obtidos ou
    /// com os erros que aconteceram
    func fetchCurrentUser(completion: @escaping (ResultHandler<CKRecord>)) {
        let operation = CKFetchRecordsOperation.fetchCurrentUserRecordOperation()
        operation.fetchRecordsCompletionBlock = { recordsByRecordID, operationError in
            if let operationError = operationError {
                return completion(.failure(operationError))
            }

            if let recordsByRecordID = recordsByRecordID,
                let userRecord = recordsByRecordID.values.first,
                let userRecordID = recordsByRecordID.keys.first {

                if userRecord.value(forKey: "name") == nil {
                    self.container.discoverUserIdentity(withUserRecordID: userRecordID) {
                        (userIdentity, error) in
                        if let error = error {
                            print(error.localizedDescription)
                        }

                        if let userIdentity = userIdentity,
                            let nameComponents = userIdentity.nameComponents {
                            let userFullName = PersonNameComponentsFormatter().string(from: nameComponents)
                            userRecord["name"] = userFullName
                        }

                        completion(.success(userRecord))
                    }
                } else {
                    completion(.success(userRecord))
                }

            }
        }
        privateDatabase.add(operation)
    }

    /// Esse método atualiza o `CKRecord` de um usuário. É update pois sempre já existe o
    /// record para o usuário quando começa a usar a aplicação.
    /// - Parameter userRecord: Record do usuário para ser salvo
    /// - Parameter completion: Callback executado quando o processo termina que retorna o record
    /// atualizado do servidor (necessário para atualizar os metadados localmente) ou os erros que aconteceram
    func update(userRecord: CKRecord, completion: @escaping (ResultHandler<CKRecord>)) {
        save(userRecord, in: privateDatabase, completion: completion)
    }

}
