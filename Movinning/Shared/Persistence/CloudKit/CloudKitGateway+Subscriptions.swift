//
//  CloudKitGateway+Subscriptions.swift
//  Movinning
//
//  Created by Matheus Oliveira Costa on 08/10/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import Foundation
import CloudKit
import PromiseKit

// MARK: - Subscriptions
extension CloudKitGateway {

    func subscriptionForUpdates(recordType: CKRecord.RecordType, objectUUID: String) -> CKQuerySubscription {
        let subscription = CKQuerySubscription(
            recordType: recordType,
            predicate: NSPredicate(format: "id == %@", objectUUID),
            subscriptionID: "team-update",
            options: [
                CKQuerySubscription.Options.firesOnRecordUpdate,
                CKQuerySubscription.Options.firesOnRecordDeletion
            ]
        )

        let info = CKSubscription.NotificationInfo()
        info.category = "team-update"
        info.shouldSendContentAvailable = true

        subscription.notificationInfo = info

        return subscription
    }

    func save(
        _ subscripitions: [CKSubscription],
        andRemove subscriptionsToRemove: [CKSubscription.ID]? = nil,
        completion: @escaping(ResultHandler<Bool>)
    ) {
        let operation = CKModifySubscriptionsOperation(
            subscriptionsToSave: subscripitions,
            subscriptionIDsToDelete: subscriptionsToRemove
        )
        operation.qualityOfService = .utility
        operation.modifySubscriptionsCompletionBlock = { _, _, error in
            if let error = error {
                completion(.failure(error))
            }

            print("Subscriptions salvas")
            completion(.success(true))
        }

        publicDatabase.add(operation)
    }

    func save(
        _ subscripitions: [CKSubscription],
        andRemove subscriptionsToRemove: [CKSubscription.ID]? = nil
    ) -> Promise<Bool> {
        return Promise<Bool> { seal in
            let operation = CKModifySubscriptionsOperation(
                subscriptionsToSave: subscripitions,
                subscriptionIDsToDelete: subscriptionsToRemove
            )
            operation.qualityOfService = .utility

            operation.modifySubscriptionsCompletionBlock = { _, _, error in
                if let error = error {
                    seal.reject(error)
                }

                print("Subscriptions salvas")
                seal.fulfill(true)
            }

            publicDatabase.add(operation)
        }
    }

    func removeSubscriptions(completion: @escaping (ResultHandler<Bool>)) {
        let userSubscriptionsOperation = CKFetchSubscriptionsOperation.fetchAllSubscriptionsOperation()

        userSubscriptionsOperation.fetchSubscriptionCompletionBlock = { subscriptions, error in
            if let error = error {
                return completion(.failure(error))
            }

            if let subscriptions = subscriptions {
                let subscriptionsToRemove = Array(subscriptions.keys)

                print("Removendo subscriptions")
                self.save([], andRemove: subscriptionsToRemove, completion: completion)
            } else {
                completion(.success(true))
            }

        }

        publicDatabase.add(userSubscriptionsOperation)
    }

    func removeSubscriptions() -> Promise<Bool> {
        return Promise<[CKSubscription.ID: CKSubscription]?> { seal in
            let userSubscriptionsOperation = CKFetchSubscriptionsOperation.fetchAllSubscriptionsOperation()

            userSubscriptionsOperation.fetchSubscriptionCompletionBlock = seal.resolve

            publicDatabase.add(userSubscriptionsOperation)
        }
        .compactMap { $0?.keys }
        .map(Array.init)
        .then { subscriptionsToRemove in
            self.save([], andRemove: subscriptionsToRemove)
        }
    }

}
