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

class StorageGateway {

    private let cloudKitGateway: CloudKitGateway
    private let coreDataGateway: CoreDataGateway

    init() {
        self.cloudKitGateway = CloudKitGateway(container:
            CKContainer(identifier: "iCloud.academy.the-rest-of-us.FinalChallenge"))
        self.coreDataGateway = CoreDataGateway(viewContext: CoreDataManager.context)
    }

    func startRegistration(completion: @escaping (ResultHandler<[String: String]>)) {
        cloudKitGateway.userRecordID { [weak self] (result) in
            switch result {
            case .success(let userRecordID):
                self?.cloudKitGateway.userIdentity(recordID: userRecordID, completion: { (userIdentity) in
                    guard let userIdentity = userIdentity else { return }
                    if let nameComponents = userIdentity.nameComponents {
                        let userFullName = PersonNameComponentsFormatter().string(from: nameComponents)
                        completion(.success(["userFullName": userFullName]))
                    }
                })
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func completeRegistration(of user: User, completion: @escaping ((Bool) -> Void)) {
        coreDataGateway.save(user) { [weak self] (result) in
            switch result {
            case .success(let user):
                let userRecord = user.asCKRecord()
                self?.cloudKitGateway.completeRegistration(of: userRecord) { (result) in
                    switch result {
                    case .success(let success):
                        completion(success)
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

    func loginUser(with recordID: CKRecord.ID, completion: @escaping (ResultHandler<User>)) {
        cloudKitGateway.loginUser(with: recordID) { [weak self] (result) in
            switch result {
            case .success(let userData):
                self?.coreDataGateway.login(with: userData, completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

}
