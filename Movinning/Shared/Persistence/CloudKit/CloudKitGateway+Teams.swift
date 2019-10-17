//
//  CloudKitGateway+Teams.swift
//  Movinning
//
//  Created by Matheus Oliveira Costa on 29/09/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import Foundation
import CloudKit
import PromiseKit

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

    /// Obtém os usuários de um time baseado na lista de referências de usuários. Retorna `CKRecord`s com
    /// somente o `firstName` e `photo`, pois os outros dados são desnecessários.
    /// - Parameter teamRecord: `CKRecord` do time usado pela consulta
    /// - Parameter completion: Callback executado quando termina a consulta com os resultados,
    /// ou os errors encontrados
    func users(from teamRecord: CKRecord, completion: @escaping(ResultHandler<[CKRecord]>)) {
        if let usersReferences = teamRecord.value(forKey: "users") as? [CKRecord.Reference] {
            let usersRecordsIDs = usersReferences.map { $0.recordID }

            let fetchOperation = CKFetchRecordsOperation(recordIDs: usersRecordsIDs)
            fetchOperation.desiredKeys = ["id", "firstName", "photo"]

            fetchOperation.fetchRecordsCompletionBlock = { recordsByRecordsIDs, error in
                if let error = error {
                    return completion(.failure(error))
                }

                if let recordsByRecordsIDs = recordsByRecordsIDs {
                    let records = Array(recordsByRecordsIDs.values)
                    completion(.success(records))
                } else {
                    completion(.success([]))
                }
            }

            publicDatabase.add(fetchOperation)
        }
    }

    /// Obtém o record do time cadastrado com o usuário, mas caso não haja nenhum,
    /// será retornado um erro.
    /// - Parameter userRecord: Record do usuário para buscar o time
    func team(of userRecord: CKRecord) -> Promise<CKRecord> {
        return Promise<CKRecord.Reference> { seal in
            guard let teamReference = userRecord.value(forKey: "team") as? CKRecord.Reference else {
                return seal.reject(CKGError.missingTeamReference)
            }

            return seal.fulfill(teamReference)
        }.then { teamReference in
            self.publicDatabase.fetch(withRecordID: teamReference.recordID)
        }
    }

    /// Esse método cria um `CKRecord` de um time.
    /// - Parameter userRecord: Record do time para ser salvo
    /// - Parameter completion: Callback executado quando o processo termina que retorna o record
    /// atualizado do servidor (necessário para atualizar os metadados localmente) ou os erros que aconteceram
    func create(
        teamRecord: CKRecord,
        withCreator userRecord: CKRecord,
        completion: @escaping (ResultHandler<(CKRecord, CKRecord)>)
    ) {
        // Configura o record do time
        let userReference = userRecord.reference(action: .none)
        teamRecord["users"] = [userReference]
        teamRecord["creator"] = userReference

        userRecord["team"] = teamRecord.reference(action: .none)

        save([teamRecord, userRecord], in: publicDatabase) { (result) in
            switch result {
            case .success(let updatedRecords):
                let updatedTeamRecord = updatedRecords[0]
                let updatedUserRecord = updatedRecords[1]
                completion(.success((updatedTeamRecord, updatedUserRecord)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func create(teamRecord: CKRecord) -> Promise<CKRecord> {
        return Promise { save([teamRecord], in: publicDatabase, completion: $0.resolve) }.firstValue
    }

}
