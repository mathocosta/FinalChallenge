//
//  StorageGateway.swift
//  FinalChallenge
//
//  Created by Matheus Oliveira Costa on 10/09/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import Foundation
import CloudKit
import PromiseKit

typealias ResultHandler<T> = ((Swift.Result<T, Error>) -> Void)

class SessionManager {

    static let current = SessionManager()

    private let cloudKitGateway: CloudKitGateway
    private let coreDataGateway: CoreDataGateway

    init() {
        self.cloudKitGateway = CloudKitGateway(container:
            CKContainer(identifier: "iCloud.academy.the-rest-of-us.Splay"))
        self.coreDataGateway = CoreDataGateway(viewContext: CoreDataStore.context)
    }

    // MARK: - User management
    func loginUser() -> Promise<Bool> {
        return userIsLogged().then { _ in
            self.cloudKitGateway.fetchInitialData().then { records -> Promise<Bool> in
                let (userRecord, teamRecord) = records
                let user = UserManager.createUser(with: userRecord.recordKeysAndValues())

                if let teamRecord = teamRecord {
                    let team = TeamManager.createTeam(with: teamRecord.recordKeysAndValues())
                    team.addToMembers(user)
                }

                return Promise<Bool> { seal in
                    self.coreDataGateway.save(user) { (result) in
                        switch result {
                        case .success:
                            seal.fulfill(true)
                        case .failure(let error):
                            seal.reject(error)
                        }
                    }
                }
            }
        }
    }

    func updateRegister(of user: User, completion: @escaping (ResultHandler<Bool>)) {
        coreDataGateway.save(user) { [weak self] (result) in
            switch result {
            case .success(let user):
                let userRecord = user.asCKRecord()
                self?.cloudKitGateway.update(userRecord: userRecord) { (result) in
                    switch result {
                    case .success(let updatedRecord):
                        let recordMetadata = updatedRecord.recordMetadata()
                        UserManager.update(recordMetadata: recordMetadata, of: user)
                        completion(.success(true))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func updateRegister(of user: User) -> Promise<Bool> {
        let userRecord = user.asCKRecord()
        return cloudKitGateway.update(userRecord: userRecord).then { updatedRecord -> Promise<Bool> in
            let recordMetadata = updatedRecord.recordMetadata()
            UserManager.update(recordMetadata: recordMetadata, of: user)

            return Promise.value(true)
        }
    }

    /// Retorna o status da conta do iCloud do usuário no dispositivo. Se retornar
    /// `true` quer dizer que está logado e pode continuar, no contrário, o usuário não
    /// está mais logado no dispositivo.
    func userIsLogged() -> Promise<Bool> {
        cloudKitGateway.userAccountAvailable()
    }

    // MARK: - Teams management
    func updateLocallyTeam(of user: User, completion: @escaping (ResultHandler<Bool>)) {
        // FIXME: Precisa refatorar para voltar a funcionar
//        let userRecord = user.asCKRecord()
//        if let userTeam = user.team {
//            cloudKitGateway.team(of: userRecord) { (result) in
//                switch result {
//                case .success(let teamRecord):
//                    let teamRecordInfo = teamRecord.recordKeysAndValues()
//                    TeamManager.update(team: userTeam, with: teamRecordInfo)
//                    self.coreDataGateway.save(userTeam) { (result) in
//                        if case .success = result {
//                            completion(.success(true))
//                        } else if case .failure(let error) = result {
//                            completion(.failure(error))
//                        }
//                    }
//                case .failure(let error):
//                    completion(.failure(error))
//                }
//            }
//        } else {
//            completion(.success(false))
//        }
    }

    func add(user: User, to team: Team, completion: @escaping (ResultHandler<Bool>)) {
        user.team = team
        updateRegister(of: user) { [weak self] _ in
            self?.addSubscriptions(for: user, completion: completion)
        }
    }

    func remove(user: User, from team: Team, completion: @escaping (ResultHandler<Bool>)) {
        team.removeFromMembers(user)
        updateRegister(of: user) { [weak self] _ in
            self?.removeSubscriptions(for: user, completion: completion)
        }
    }

    func listTeams(completion: @escaping (ResultHandler<[Team]>)) {
        cloudKitGateway.listTeams { (result) in
            switch result {
            case .success(_, let records):
                var teams = [Team]()
                for record in records {
                    let recordInfo = record.recordKeysAndValues()
                    teams.append(TeamManager.createTeam(with: recordInfo))
                }
                completion(.success(teams))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func create(team: Team, with user: User, completion: @escaping (ResultHandler<Bool>)) {
        let teamRecord = team.asCKRecord()
        cloudKitGateway.create(teamRecord: teamRecord) { (result) in
            switch result {
            case .success(let updatedTeamRecord):
                TeamManager.update(recordMetadata: updatedTeamRecord.recordMetadata(), of: team)
                self.add(user: user, to: team, completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    // MARK: - Subscriptions
    private func addSubscriptions(for user: User, completion: @escaping (ResultHandler<Bool>)) {
        if let teamUUID = user.team?.id?.uuidString {
            print("Adicionando subscriptions para time: \(teamUUID)")
            let subscription = cloudKitGateway.subscriptionForUpdates(recordType: "Teams", objectUUID: teamUUID)
            cloudKitGateway.save([subscription], completion: completion)
        }
    }

    private func removeSubscriptions(for user: User, completion: @escaping (ResultHandler<Bool>)) {
        cloudKitGateway.removeSubscriptions(completion: completion)
    }
}
