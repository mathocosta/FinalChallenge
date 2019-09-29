//
//  StorageGateway.swift
//  FinalChallenge
//
//  Created by Matheus Oliveira Costa on 10/09/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import Foundation
import CloudKit

typealias ResultHandler<T> = ((Result<T, Error>) -> Void)

class SessionManager {

    static let current = SessionManager()

    private let cloudKitGateway: CloudKitGateway
    private let coreDataGateway: CoreDataGateway

    init() {
        self.cloudKitGateway = CloudKitGateway(container:
            CKContainer(identifier: "iCloud.academy.the-rest-of-us.Splay"))
        self.coreDataGateway = CoreDataGateway(viewContext: CoreDataStore.context)
    }

    func loginUser(completion: @escaping (ResultHandler<Bool>)) {
        cloudKitGateway.userAccountAvailable { [weak self] (userAccountAvailableResult) in
            switch userAccountAvailableResult {
            case .success(let isAvailable):
                if isAvailable {
                    self?.cloudKitGateway.fetchInitialData { (initialDataResult) in
                        switch initialDataResult {
                        case .success(let userRecord, let teamRecord):
                            let user = UserManager.createUser(with: userRecord.recordKeysAndValues())

                            if let teamRecord = teamRecord {
                                let team = TeamManager.createTeam(with: teamRecord.recordKeysAndValues())
                                team.addToMembers(user)
                            }

                            self?.coreDataGateway.save(user) { (saveResult) in
                                switch saveResult {
                                case .success:
                                    completion(.success(true))
                                case .failure(let error):
                                    completion(.failure(error))
                                }
                            }
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                } else {
                    let nsError = NSError(domain: "User not logged", code: 0, userInfo: nil)
                    completion(.failure(nsError))
                }
            case .failure(let error):
                completion(.failure(error))
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
    
    /// Retorna o status da conta do iCloud do usuário no dispositivo. Se retornar
    /// `true` quer dizer que está logado e pode continuar, no contrário, o usuário não
    /// está mais logado no dispositivo.
    /// - Parameter completion: Callback com o resultado ou com os possiveis erros
    func userIsLogged(completion: @escaping (ResultHandler<Bool>)) {
        cloudKitGateway.userAccountAvailable(completion: completion)
    }

    func add(user: User, to team: Team, completion: @escaping (ResultHandler<Bool>)) {
        user.team = team
        updateRegister(of: user, completion: completion)
    }

    func remove(user: User, from team: Team, completion: @escaping (ResultHandler<Bool>)) {
        team.removeFromMembers(user)
        updateRegister(of: user, completion: completion)
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

}
