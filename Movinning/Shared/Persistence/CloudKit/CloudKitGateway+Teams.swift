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

    /// Obtém o record do time cadastrado com o usuário, mas caso não haja nenhum,
    /// será retornado um erro.
    /// - Parameter userRecord: Record do usuário para buscar o time
    func team(of userRecord: CKRecord) -> Promise<CKRecord> {
        return Promise<CKRecord.Reference> { seal in
            guard let teamReference = userRecord.value(forKey: "team") as? CKRecord.Reference else {
                let nsError = NSError(domain: "User doesn't have a team", code: 1, userInfo: nil)
                return seal.reject(nsError)
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
    func create(teamRecord: CKRecord, completion: @escaping (ResultHandler<CKRecord>)) {
        save(teamRecord, in: publicDatabase, completion: completion)
    }

}
