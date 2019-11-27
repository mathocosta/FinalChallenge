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

extension Notification.Name {
    static let userPointsDidChange = Notification.Name("SessionManager.userPointsDidChange")
}

class SessionManager {

    static let current = SessionManager()

    private let cloudKitManager: OnlinePersistenceGateway
    private let coreDataGateway: CoreDataGateway

    private var listTeamsOperationCursor: CKQueryOperation.Cursor?

    init(cloudKitManager: OnlinePersistenceGateway = CloudKitManager(container: CKContainer(identifier: "iCloud.academy.the-rest-of-us.Splay")),
         coreDataGateway: CoreDataGateway = CoreDataGateway(viewContext: CoreDataStore.context)) {

        self.cloudKitManager = cloudKitManager
        self.coreDataGateway = coreDataGateway

        NotificationCenter.default.addObserver(self,
            selector: #selector(uploadPoints(_:)),
            name: .userPointsDidChange,
            object: nil
        )
    }

    // MARK: - User management
    func loginUser() -> Promise<Bool> {
        return userIsLogged().then { _ in
            self.cloudKitManager.fetchInitialData().then { records -> Promise<Bool> in
                let (userRecord, teamRecord) = records
                let user = UserManager.createUser(with: userRecord.recordKeysAndValues())

                if let teamRecord = teamRecord {
                    let team = TeamManager.createTeam(with: teamRecord.recordKeysAndValues())
                    team.addToMembers(user)
                }

                UserDefaults.standard.loggedUserUUID = user.id?.uuidString

                return self.coreDataGateway.save(user)
            }
        }
    }

    func updateRegister(of user: User) -> Promise<Bool> {
        let userRecord = user.ckRecord()
        return cloudKitManager.update(userRecord: userRecord).then { updatedRecord -> Promise<Bool> in
            let recordMetadata = updatedRecord.recordMetadata()
            UserManager.update(recordMetadata: recordMetadata, of: user)

            return self.coreDataGateway.save(user)
        }
    }

    /// Retorna o status da conta do iCloud do usuário no dispositivo. Se retornar
    /// `true` quer dizer que está logado e pode continuar, no contrário, o usuário não
    /// está mais logado no dispositivo.
    func userIsLogged() -> Promise<Bool> {
        cloudKitManager.userAccountAvailable()
    }

    @objc func uploadPoints(_ notification: Notification) {
        guard let loggedUser = UserManager.getLoggedUser() else { return }
        var recordsToUpdate = [loggedUser.ckRecord()]

        if let userTeam = loggedUser.team {
            recordsToUpdate.append(userTeam.ckRecord())
        }

        _ = cloudKitManager.save(recordsToUpdate)
            .done { _ in print("Pontos atualizados no servidor") }
    }

    // MARK: - Teams management
    func updateLocallyTeam(of user: User) -> Promise<Bool> {
        guard let userTeam = user.team else { return Promise(error: SessionError.userDontHaveTeam) }
        let userRecord = user.ckRecord()
        return cloudKitManager.team(of: userRecord).then { (teamRecord) -> Promise<Bool> in
            let teamRecordInfo = teamRecord.recordKeysAndValues()
            TeamManager.update(team: userTeam, with: teamRecordInfo)
            return self.coreDataGateway.save(userTeam)
        }
    }

    func add(user: User, to team: Team) -> Promise<Bool> {
        return self.cloudKitManager.add(userRecord: user.ckRecord(), to: team.ckRecord()).then {
            results -> Promise<Bool> in
            let (updatedUserRecord, updatedTeamRecord) = results
            UserManager.update(recordMetadata: updatedUserRecord.recordMetadata(), of: user)
            TeamManager.update(team: team, with: updatedTeamRecord.recordKeysAndValues())

            user.team = team
            return self.coreDataGateway.save(user)
        }.then { _ in
            self.addSubscriptions(for: user)
        }
    }

    func remove(user: User, from team: Team) -> Promise<Bool> {
        let userRecord = user.ckRecord()
        let teamRecord = team.ckRecord()

        return cloudKitManager.remove(userRecord: userRecord, from: teamRecord).then {
            updatedUserRecord -> Promise<Bool> in
            team.removeFromMembers(user)
            UserManager.update(recordMetadata: updatedUserRecord.recordMetadata(), of: user)
            return self.coreDataGateway.save(user)
        }.then { _ in self.removeSubscriptions() }
    }

    func listTeams(state: TeamListView.State) -> Promise<(CKQueryOperation.Cursor?, [Team])> {
        var listTeamsPromise = cloudKitManager.listTeams(cursor: nil)
        if state == .loadingMoreResults {
            listTeamsPromise = cloudKitManager.listTeams(cursor: listTeamsOperationCursor)
        }

        return listTeamsPromise.then({ queryResult -> Promise<[CKRecord]> in
            let (actualCursor, records) = queryResult
            self.listTeamsOperationCursor = actualCursor
            return Promise.value(records)
        }).thenMap { teamRecord in
            self.cloudKitManager.users(from: teamRecord).map({ (teamRecord, $0) })
        }.thenMap { results -> Promise<Team> in
            let (teamRecord, usersRecords) = results
            let team = TeamManager.createTeam(with: teamRecord.recordKeysAndValues())
            for userRecord in usersRecords {
                let user = UserManager.createUser(with: userRecord.recordKeysAndValues())
                team.addToMembers(user)
            }

            return Promise.value(team)
        }.then { teams in
            return Promise.value((self.listTeamsOperationCursor, teams))
        }
    }

    func users(from team: Team, of user: User) -> Promise<[User]> {
        return cloudKitManager.team(of: user.ckRecord()).then {
            teamRecord -> Promise<[CKRecord]> in
            TeamManager.update(team: team, with: teamRecord.recordKeysAndValues())
            return self.cloudKitManager.users(from: teamRecord)
        }.thenMap { userRecord -> Promise<User> in
            Promise.value(UserManager.createUser(with: userRecord.recordKeysAndValues()))
        }.map { users in
            users.sorted(by: { $0.points > $1.points })
        }
    }

    func create(team: Team, with user: User) -> Promise<Bool> {
        let teamRecord = team.ckRecord()
        let userRecord = user.ckRecord()

        return cloudKitManager.create(teamRecord: teamRecord, withCreator: userRecord).then {
            updatedRecords -> Promise<Bool> in

            let (updatedTeamRecord, updatedUserRecord) = updatedRecords
            TeamManager.update(recordMetadata: updatedTeamRecord.recordMetadata(), of: team)
            UserManager.update(recordMetadata: updatedUserRecord.recordMetadata(), of: user)
            user.team = team

            return self.addSubscriptions(for: user)
        }
    }

    // MARK: - Subscriptions
    private func addSubscriptions(for user: User) -> Promise<Bool> {
        guard let teamUUID = user.team?.id?.uuidString else {
            return Promise(error: SessionError.missingTeamIdentifier)
        }
        print("Adicionando subscriptions para time: \(teamUUID)")
        let subscription = cloudKitManager.subscriptionForUpdates(recordType: "Teams", objectUUID: teamUUID)

        return cloudKitManager.save([subscription], andRemove: nil)
    }

    func removeSubscriptions() -> Promise<Bool> {
        cloudKitManager.removeSubscriptions()
    }
}
