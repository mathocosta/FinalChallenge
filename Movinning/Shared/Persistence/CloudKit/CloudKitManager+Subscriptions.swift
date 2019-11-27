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
extension CloudKitManager {

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
