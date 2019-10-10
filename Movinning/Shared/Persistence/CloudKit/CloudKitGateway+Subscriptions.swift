//
//  CloudKitGateway+Subscriptions.swift
//  Movinning
//
//  Created by Matheus Oliveira Costa on 08/10/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import Foundation
import CloudKit

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

            print("Subscriptions adicionadas")
            completion(.success(true))
        }

        publicDatabase.add(operation)
    }

    func updateSubscriptions(
        with newSubscriptions: [CKSubscription], completion: @escaping (ResultHandler<Bool>)) {
        let userSubscriptionsOperation = CKFetchSubscriptionsOperation.fetchAllSubscriptionsOperation()

        userSubscriptionsOperation.fetchSubscriptionCompletionBlock = { subscriptions, error in
            if let error = error {
                return completion(.failure(error))
            }

            if let subscriptions = subscriptions {
                let alreadySaved = Array(subscriptions.keys)
                let toUpdate = newSubscriptions.map { $0.subscriptionID }
                let subscriptionsToRemove = alreadySaved.filter(toUpdate.contains)

                print("Atualizando subscriptions")
                self.save(newSubscriptions, andRemove: subscriptionsToRemove, completion: completion)
            }
        }

        publicDatabase.add(userSubscriptionsOperation)
    }

}
