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
            CKContainer(identifier: "iCloud.academy.the-rest-of-us.FinalChallenge"))
        self.coreDataGateway = CoreDataGateway(viewContext: CoreStataStore.context)
    }

    func loginUser(completion: @escaping (ResultHandler<Bool>)) {
        cloudKitGateway.canUseUserData { [weak self] (success, error) in
            if let error = error {
                return completion(.failure(error))
            }

            if success {
                self?.cloudKitGateway.fetchCurrentUser { (result) in
                    switch result {
                    case .success(let record):
                        let userRecordInfo = record.recordKeysAndValues()
                        let newUser = UserManager.createUser(with: userRecordInfo)
                        self?.coreDataGateway.save(newUser) { _ in
                            completion(.success(true))
                        }
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }

    func updateRegister(of user: User, completion: @escaping ((Bool) -> Void)) {
        coreDataGateway.save(user) { [weak self] (result) in
            switch result {
            case .success(let user):
                let userRecord = user.asCKRecord()
                self?.cloudKitGateway.update(userRecord: userRecord) { (result) in
                    switch result {
                    case .success(let updatedRecord):
                        let recordMetadata = updatedRecord.recordMetadata()
                        UserManager.update(recordMetadata: recordMetadata, of: user)
                        completion(true)
                    case .failure(let error):
                        print(error.localizedDescription)
                        completion(false)
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
                completion(false)
            }
        }
    }

}
