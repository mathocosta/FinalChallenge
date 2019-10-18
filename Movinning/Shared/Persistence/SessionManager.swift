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

                return self.coreDataGateway.save(user)
            }
        }
    }

    func updateRegister(of user: User, completion: @escaping (ResultHandler<Bool>)) {
        coreDataGateway.save(user) { [weak self] (result) in
            switch result {
            case .success(let user):
                let userRecord = user.ckRecord()
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
        let userRecord = user.ckRecord()
        return cloudKitGateway.update(userRecord: userRecord).then { updatedRecord -> Promise<Bool> in
            let recordMetadata = updatedRecord.recordMetadata()
            UserManager.update(recordMetadata: recordMetadata, of: user)

            return self.coreDataGateway.save(user)
        }
    }

    /// Retorna o status da conta do iCloud do usuário no dispositivo. Se retornar
    /// `true` quer dizer que está logado e pode continuar, no contrário, o usuário não
    /// está mais logado no dispositivo.
    func userIsLogged() -> Promise<Bool> {
        cloudKitGateway.userAccountAvailable()
    }

    // MARK: - Teams management
    func updateLocallyTeam(of user: User) -> Promise<Bool> {
        guard let userTeam = user.team else { return Promise(error: SessionError.userDontHaveTeam) }
        let userRecord = user.ckRecord()
        return cloudKitGateway.team(of: userRecord).then { (teamRecord) -> Promise<Bool> in
            let teamRecordInfo = teamRecord.recordKeysAndValues()
            TeamManager.update(team: userTeam, with: teamRecordInfo)
            return self.coreDataGateway.save(userTeam)
        }
    }

    func add(user: User, to team: Team, completion: @escaping (ResultHandler<Bool>)) {
        user.team = team
        updateRegister(of: user) { [weak self] _ in
            self?.addSubscriptions(for: user, completion: completion)
        }
    }

    func remove(user: User, from team: Team) -> Promise<Bool> {
        let userRecord = user.ckRecord()
        let teamRecord = team.ckRecord()

        return cloudKitGateway.remove(userRecord: userRecord, from: teamRecord).then {
            (updatedUserRecord) -> Promise<Bool> in
            team.removeFromMembers(user)
            UserManager.update(recordMetadata: updatedUserRecord.recordMetadata(), of: user)
            return self.coreDataGateway.save(user)
        }.then { _ in self.removeSubscriptions() }
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

    func users(from team: Team, completion: @escaping (ResultHandler<[User]>)) {
        let teamRecord = team.ckRecord()
        cloudKitGateway.users(from: teamRecord) { (result) in
            switch result {
            case .success(let usersRecords):
                var users = [User]()
                for record in usersRecords {
                    users.append(UserManager.createUser(with: record.recordKeysAndValues()))
                }
                completion(.success(users))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func create(team: Team, with user: User) -> Promise<Bool> {
        let teamRecord = team.ckRecord()
        let userRecord = user.ckRecord()

        return cloudKitGateway.create(teamRecord: teamRecord, withCreator: userRecord).then {
            updatedRecords -> Promise<Bool> in

            let (updatedTeamRecord, updatedUserRecord) = updatedRecords
            TeamManager.update(recordMetadata: updatedTeamRecord.recordMetadata(), of: team)
            UserManager.update(recordMetadata: updatedUserRecord.recordMetadata(), of: user)
            user.team = team

            return self.addSubscriptions(for: user)
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

    private func addSubscriptions(for user: User) -> Promise<Bool> {
        guard let teamUUID = user.team?.id?.uuidString else {
            return Promise(error: SessionError.missingTeamIdentifier)
        }
        print("Adicionando subscriptions para time: \(teamUUID)")
        let subscription = cloudKitGateway.subscriptionForUpdates(recordType: "Teams", objectUUID: teamUUID)

        return cloudKitGateway.save([subscription])
    }

    func removeSubscriptions() -> Promise<Bool> {
        cloudKitGateway.removeSubscriptions()
    }
}
