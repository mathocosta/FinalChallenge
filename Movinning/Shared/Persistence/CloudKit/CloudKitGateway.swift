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
                print("Records salvos: \(savedRecords)")
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
        query.sortDescriptors = [NSSortDescriptor(key: "firstName", ascending: true),NSSortDescriptor(key: "lastName", ascending: true)]

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

                if userRecord.value(forKey: "firstName") == nil, userRecord.value(forKey: "lastName") == nil {
                    self.container.discoverUserIdentity(withUserRecordID: userRecordID) {
                        (userIdentity, error) in
                        if let error = error {
                            print(error.localizedDescription)
                        }

                        if let userIdentity = userIdentity,
                            let nameComponents = userIdentity.nameComponents {
                            if let firstName = nameComponents.givenName,
                                let middleName = nameComponents.middleName,
                                let familyName = nameComponents.familyName {
                                userRecord["firstName"] = firstName
                                userRecord["lastName"] = middleName + familyName
                            }
                        }

                        completion(.success(userRecord))
                    }
                } else {
                    completion(.success(userRecord))
                }

            }
        }
        publicDatabase.add(operation)
    }

    /// Esse método obtém os dados do usuário e também os dados do time que está cadastrado na conta
    /// do usuário. Dois métodos são usados para isso funcionar, um para buscar o record do usuário
    /// e outro para o record do time, já que no usuário está apenas a referência.
    /// - Parameter completion: Callback executado quando todos os dados forem baixados ou
    /// com os erros que aconteceram
    func fetchInitialData(completion: @escaping (ResultHandler<(CKRecord, CKRecord?)>)) {
        fetchCurrentUser { (result) in
            switch result {
            case .success(let userRecord):
                // Tenta baixar o record do time, caso dê erro, é porque
                // não tem um time cadastrado para o usuário.
                self.team(of: userRecord) { (result) in
                    switch result {
                    case .success(let teamRecord):
                        completion(.success((userRecord, teamRecord)))
                    case .failure(let error):
                        print(error.localizedDescription)
                        completion(.success((userRecord, nil)))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    /// Esse método atualiza o `CKRecord` de um usuário. É update pois sempre já existe o
    /// record para o usuário quando começa a usar a aplicação.
    /// - Parameter userRecord: Record do usuário para ser salvo
    /// - Parameter completion: Callback executado quando o processo termina que retorna o record
    /// atualizado do servidor (necessário para atualizar os metadados localmente) ou os erros que aconteceram
    func update(userRecord: CKRecord, completion: @escaping (ResultHandler<CKRecord>)) {
        save(userRecord, in: publicDatabase, completion: completion)
    }

    /// Remove a referência do time no usuário. Depois é feito o update dos dados no servidor.
    /// - Parameter userRecord: Record do usuário para ser atualizado e salvo
    /// - Parameter completion: Callback executado quando o processo termina que retorna o record
    /// atualizado do servidor (necessário para atualizar os metadados localmente) ou os erros que aconteceram
    func removeTeamReference(from userRecord: CKRecord, completion: @escaping (ResultHandler<CKRecord>)) {
        userRecord["team"] = nil
        update(userRecord: userRecord, completion: completion)
    }

}

// MARK: - Gerenciamento dos times
extension CloudKitGateway {

    /// Faz uma consulta pelos times salvos na database. Pode receber como parâmetro o
    /// `CKQueryOperation.Cursor` da consulta passada para continuar caso seja necessário.
    /// - Parameter cursor: Onde deve começar a consulta
    /// - Parameter completion: Callback executado quando termina a consulta, com o cursor atual e
    /// os records obtidos, ou os errors encontrados
    func listTeams(
        cursor: CKQueryOperation.Cursor? = nil,
        completion: @escaping (ResultHandler<(CKQueryOperation.Cursor?, [CKRecord])>)
    ) {
        var fetchedRecords = [CKRecord]()
        var queryOperation: CKQueryOperation

        if let cursor = cursor {
            queryOperation = CKQueryOperation(cursor: cursor)
        } else {
            let query = CKQuery(recordType: "Teams", predicate: NSPredicate(value: true))
            queryOperation = CKQueryOperation(query: query)
        }

        queryOperation.cursor = nil
        queryOperation.resultsLimit = 10

        queryOperation.recordFetchedBlock = { (fetchedRecord) in
            fetchedRecords.append(fetchedRecord)
        }

        queryOperation.queryCompletionBlock = { (nextCursor, operationError) in
            if let operationError = operationError {
                completion(.failure(operationError))
            }

            completion(.success((nextCursor, fetchedRecords)))
        }

        publicDatabase.add(queryOperation)
    }

    /// Obtém o record do time cadastrado com o usuário, mas caso não haja nenhum,
    /// será retornado um erro.
    /// - Parameter userRecord: Record do usuário para buscar o time
    /// - Parameter completion: Callback executado quando termina a consulta, com o cursor atual e
    /// os records obtidos, ou os errors encontrados
    func team(of userRecord: CKRecord, completion: @escaping (ResultHandler<CKRecord>)) {
        guard let teamReference = userRecord.value(forKey: "team") as? CKRecord.Reference else {
            let nsError = NSError(domain: "User doesn't have a team", code: 1, userInfo: nil)
            return completion(.failure(nsError))
        }

        object(with: teamReference.recordID, in: publicDatabase, completion: completion)
    }

    /// Esse método cria um `CKRecord` de um time.
    /// - Parameter userRecord: Record do time para ser salvo
    /// - Parameter completion: Callback executado quando o processo termina que retorna o record
    /// atualizado do servidor (necessário para atualizar os metadados localmente) ou os erros que aconteceram
    func create(teamRecord: CKRecord, completion: @escaping (ResultHandler<CKRecord>)) {
        save(teamRecord, in: publicDatabase, completion: completion)
    }

}
