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
            CKContainer(identifier: "iCloud.academy.the-rest-of-us.FinalChallenge-paulo"))
        self.coreDataGateway = CoreDataGateway(viewContext: CoreStataStore.context)
    }

    func loginUser(completion: @escaping (ResultHandler<Bool>)) {
        cloudKitGateway.canUseUserData { [weak self] (success, error) in
            if let error = error {
                return completion(.failure(error))
            }

            if success {
                self?.cloudKitGateway.fetchInitialData { (result) in
                    switch result {
                    case .success(let userRecord, let teamRecord):
                        let user = UserManager.createUser(with: userRecord.recordKeysAndValues())
                        let team = TeamManager.createTeam(with: teamRecord.recordKeysAndValues())

                        team.addToMembers(user)

                        self?.coreDataGateway.save(user) { (result) in
                            switch result {
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

}
