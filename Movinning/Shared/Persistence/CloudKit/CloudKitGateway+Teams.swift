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
    func listTeams(cursor: CKQueryOperation.Cursor? = nil) -> Promise<(CKQueryOperation.Cursor?, [CKRecord])> {
        return Promise<(CKQueryOperation.Cursor?, [CKRecord])> { seal in
            var fetchedRecords = [CKRecord]()
            var queryOperation: CKQueryOperation
            if let cursor = cursor {
                queryOperation = CKQueryOperation(cursor: cursor)
            } else {
                let query = CKQuery(recordType: "Teams", predicate: NSPredicate(value: true))
                queryOperation = CKQueryOperation(query: query)
            }

            queryOperation.resultsLimit = 10
            queryOperation.recordFetchedBlock = { fetchedRecord in
                fetchedRecords.append(fetchedRecord)
            }

            queryOperation.queryCompletionBlock = { nextCursor, operationError in
                if let operationError = operationError {
                    seal.reject(operationError)
                }

                return seal.fulfill((nextCursor, fetchedRecords))
            }

            publicDatabase.add(queryOperation)
        }
    }

    /// Obtém os usuários de um time baseado na lista de referências de usuários. Retorna `CKRecord`s com
    /// somente o `firstName` e `photo`, pois os outros dados são desnecessários.
    /// - Parameter teamRecord: `CKRecord` do time usado pela consulta
    func users(from teamRecord: CKRecord) -> Promise<[CKRecord]> {
        return Promise<[CKRecord.ID: CKRecord]> { seal in
            let usersReferences = teamRecord.value(forKey: "users") as? [CKRecord.Reference]
            let usersRecordsIDs = usersReferences?.map { $0.recordID }

            let fetchOperation = CKFetchRecordsOperation(recordIDs: usersRecordsIDs ?? [])
            fetchOperation.desiredKeys = ["id", "firstName", "photo", "points"]
            fetchOperation.fetchRecordsCompletionBlock = seal.resolve

            publicDatabase.add(fetchOperation)
        }.compactMap({ $0.values }).map(Array.init)
    }

    /// Obtém o record do time cadastrado com o usuário, mas caso não haja nenhum,
    /// será retornado um erro.
    /// - Parameter userRecord: Record do usuário para buscar o time
    func team(of userRecord: CKRecord) -> Promise<CKRecord> {
        guard let teamReference = userRecord.value(forKey: "team") as? CKRecord.Reference else {
            return Promise(error: SessionError.missingTeamReference)
        }

        return publicDatabase.fetch(withRecordID: teamReference.recordID)
    }

    /// Cria um time e adiciona o usuário como criador e como membro.
    /// - Parameter teamRecord: Record do time a ser criado
    /// - Parameter userRecord: Record do usuário para atualizar
    func create(teamRecord: CKRecord, withCreator userRecord: CKRecord) -> Promise<(CKRecord, CKRecord)> {
        let userReference = userRecord.reference()
        teamRecord["users"] = [userReference]
        teamRecord["creator"] = userReference

        userRecord["team"] = teamRecord.reference()

        return Promise {
            save([teamRecord, userRecord], in: publicDatabase, completion: $0.resolve)
        }.then { updatedRecords -> Promise<(CKRecord, CKRecord)> in
            let updatedTeamRecord = updatedRecords[0]
            let updatedUserRecord = updatedRecords[1]

            return Promise.value((updatedTeamRecord, updatedUserRecord))
        }
    }

}
