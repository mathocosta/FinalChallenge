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

    func startRegistration(completion: @escaping (ResultHandler<[String: Any]>)) {
        let operation = CKUserInformationOperation()
        operation.configuration.container = cloudKitGateway.container

        operation.userInformationCompletionBlock = { userRecord, userIdentity in
            if let userRecord = userRecord {
                let recordMetadata = userRecord.recordMetadata()
                var userFullName = ""

                if let userIdentity = userIdentity, let nameComponents = userIdentity.nameComponents {
                    userFullName = PersonNameComponentsFormatter().string(from: nameComponents)
                }

                completion(.success([
                    "fullName": userFullName,
                    "recordMetadata": recordMetadata
                ]))
            }
        }

        cloudKitGateway.container.add(operation)
    }

    func loginUser(completion: @escaping (ResultHandler<Bool>)) {
        cloudKitGateway.userInfo { (result) in
            switch result {
            case .success(let userInfo):
                let user = UserManager.createUser(with: userInfo)
                self.coreDataGateway.save(user) { _ in
                    completion(.success(true))
                }
            case .failure(let error):
                completion(.failure(error))
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
