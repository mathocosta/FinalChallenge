//
//  CloudKitGateway+Users.swift
//  Movinning
//
//  Created by Matheus Oliveira Costa on 29/09/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import Foundation
import CloudKit

// MARK: - Gerenciamento dos dados dos usuários
extension CloudKitGateway {

    /// Checa se tem usuário logado no device
    /// - Parameter completion: Callback executado quando o processo é terminado e com os possíveis erros
    func userAccountAvailable(completion: @escaping (ResultHandler<Bool>)) {
        container.accountStatus { (accountStatus, error) in
            if let error = error {
                return completion(.failure(error))
            } else {
                return completion(.success(accountStatus == .available))
            }
        }
    }

    /// Solicita permissão ao usuário para utilizar os dados do usuário para preencher
    /// inicialmente o nome do usuário
    /// - Parameter completion: Callback executado quando o processo é terminado e com os possíveis erros
    func userIdentityPermission(completion: @escaping (ResultHandler<Bool>)) {
        container.requestApplicationPermission(.userDiscoverability) { (permissionStatus, error) in
            if let error = error {
                return completion(.failure(error))
            } else {
                return completion(.success(permissionStatus == .granted))
            }
        }
    }

    func identityData(of userRecordID: CKRecord.ID, completion: @escaping (ResultHandler<[String: String]>)) {
        container.discoverUserIdentity(withUserRecordID: userRecordID) {
            (userIdentity, error) in
            if let error = error {
                print(error.localizedDescription)
            }

            if let userIdentity = userIdentity,
                let nameComponents = userIdentity.nameComponents,
                let firstName = nameComponents.givenName,
                let lastName = nameComponents.familyName {

                completion(.success([
                    "firstName": firstName,
                    "lastName": lastName
                ]))
            }

            completion(.success([:]))
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
        operation.fetchRecordsCompletionBlock = { (recordsByRecordID, operationError) in
            if let operationError = operationError {
                return completion(.failure(operationError))
            }

            if let recordsByRecordID = recordsByRecordID,
                let userRecord = recordsByRecordID.values.first {

                // Checa se no record já foi inicializado alguma das propriedades customizadas
                if userRecord.value(forKey: "id") == nil {
                    self.userIdentityPermission { (identityPermissionResult) in
                        if case .failure(let error) = identityPermissionResult {
                            return completion(.failure(error))
                        } else if case .success(let isGranted) = identityPermissionResult {
                            if isGranted {
                                self.identityData(of: userRecord.recordID) { (identityDataResult) in
                                    switch identityDataResult {
                                    case .success(let userIdentityData):
                                        userRecord["firstName"] = userIdentityData["firstName"]
                                        userRecord["lastName"] = userIdentityData["lastName"]
                                        return completion(.success(userRecord))
                                    case .failure(let error):
                                        return completion(.failure(error))
                                    }
                                }
                            } else {
                                return completion(.success(userRecord))
                            }
                        }
                    }
                } else {
                    return completion(.success(userRecord))
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
