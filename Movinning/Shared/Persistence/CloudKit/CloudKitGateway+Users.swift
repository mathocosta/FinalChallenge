//
//  CloudKitGateway+Users.swift
//  Movinning
//
//  Created by Matheus Oliveira Costa on 29/09/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import Foundation
import CloudKit
import PromiseKit
import PMKCloudKit

// MARK: - Gerenciamento dos dados dos usuários
extension CloudKitGateway {

    /// Checa se tem usuário logado no device
    func userAccountAvailable() -> Promise<Bool> {
        return container.accountStatus().then { Promise.value($0 == .available) }
    }

    /// Solicita permissão ao usuário para utilizar os dados do usuário para preencher
    /// inicialmente o nome do usuário
    func userIdentityPermission() -> Promise<Bool> {
        return container.requestApplicationPermission(.userDiscoverability).then {
            Promise.value($0 == .granted)
        }
    }

    /// Obtém os dados do usuário com o record id
    /// - Parameter userRecordID: `CKRecord.ID` do usuário para obter os dados
    func identityData(of userRecordID: CKRecord.ID) -> Promise<[String: String]> {
        return container.discoverUserIdentity(withUserRecordID: userRecordID).then {
            userIdentity -> Promise<[String: String]> in

            if let nameComponents = userIdentity.nameComponents,
                let firstName = nameComponents.givenName,
                let lastName = nameComponents.familyName {

                return Promise.value([
                    "firstName": firstName,
                    "lastName": lastName
                ])
            }

            return Promise.value([:])

        }
    }

    func addIndetityData(to userRecord: CKRecord) -> Promise<CKRecord> {
        return userIdentityPermission().then { isGranted -> Promise<CKRecord> in
            if isGranted {
                return self.identityData(of: userRecord.recordID).then {
                    userIdentityData -> Promise<CKRecord> in
                    userRecord["firstName"] = userIdentityData["firstName"]
                    userRecord["lastName"] = userIdentityData["lastName"]

                    return Promise.value(userRecord)
                }
            }

            return Promise.value(userRecord)
        }
    }

    /// Esse método obtém os dados do usuário logado na conta do iCloud do dispositivo.
    /// Como pode ser que ele nunca tenha usado o app, é feito um processo de inicialização
    /// do `CKRecord` antes colocando o nome que está na conta do iCloud. Mas caso já tenha usado
    /// e o record já exista na database, é apenas retornado com os dados antigos.
    /// - Parameter completion: Callback executado quando os dados do usuário são obtidos ou
    /// com os erros que aconteceram
    func fetchCurrentUser() -> Promise<CKRecord> {
        return Promise<CKRecord> { seal in
            let operation = CKFetchRecordsOperation.fetchCurrentUserRecordOperation()
            operation.fetchRecordsCompletionBlock = { (recordsByRecordID, operationError) in
                if let operationError = operationError {
                    return seal.reject(operationError)
                }

                if let recordsByRecordID = recordsByRecordID,
                    let userRecord = recordsByRecordID.values.first {
                    return seal.fulfill(userRecord)
                }
            }
            publicDatabase.add(operation)
        }
    }

    /// Esse método obtém os dados do usuário e também os dados do time que está cadastrado na conta
    /// do usuário.
    func fetchInitialData() -> Promise<(CKRecord, CKRecord?)> {
        return firstly(execute: fetchCurrentUser)
            .then(addIndetityData)
            .then { userRecord in
                self.team(of: userRecord).then { teamRecord in
                    Promise.value((userRecord, teamRecord))
                }.recover { _ in
                    Promise.value((userRecord, nil))
                }
        }
    }

    /// Esse método atualiza o `CKRecord` de um usuário. É update pois sempre já existe o
    /// record para o usuário quando começa a usar a aplicação.
    /// - Parameter userRecord: Record do usuário para ser salvo
    func update(userRecord: CKRecord) -> Promise<CKRecord> {
        return Promise { save([userRecord], in: publicDatabase, completion: $0.resolve) }.firstValue
    }

    /// Remove a referência do time no usuário e remove a referência da lista dos usuários do time.
    /// Depois é feito o update dos dados no servidor.
    /// - Parameter userRecord: Record do usuário para ser atualizado e salvo
    /// - Parameter teamRecord: Record do time para ser atualizado
    func remove(userRecord: CKRecord, from teamRecord: CKRecord) -> Promise<CKRecord> {
        return publicDatabase.fetch(withRecordID: teamRecord.recordID).then {
            updatedTeamRecord -> Promise<CKRecord> in
            userRecord["team"] = nil

            if var usersReferences = updatedTeamRecord.value(forKey: "users") as? [CKRecord.Reference],
                let index = usersReferences.firstIndex(of: userRecord.reference()) {
                usersReferences.remove(at: index)

                return Promise {
                    self.save([userRecord, updatedTeamRecord], in: self.publicDatabase, completion: $0.resolve)
                }.firstValue
            } else {
                return self.update(userRecord: userRecord)
            }
        }
    }
}
