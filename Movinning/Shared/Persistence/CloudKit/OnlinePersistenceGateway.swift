//
//  UsersGateway.swift
//  Movinning
//
//  Created by Paulo José on 12/11/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import Foundation
import CloudKit
import PromiseKit

protocol OnlinePersistenceGateway {
    func listTeams(cursor: CKQueryOperation.Cursor?) -> Promise<(CKQueryOperation.Cursor?, [CKRecord])>
    func users(from teamRecord: CKRecord) -> Promise<[CKRecord]>
    func team(of userRecord: CKRecord) -> Promise<CKRecord>
    func create(teamRecord: CKRecord, withCreator userRecord: CKRecord) -> Promise<(CKRecord, CKRecord)>

    func userAccountAvailable() -> Promise<Bool>
    func fetchInitialData() -> Promise<(CKRecord, CKRecord?)>
    func update(userRecord: CKRecord) -> Promise<CKRecord>
    func add(userRecord: CKRecord, to teamRecord: CKRecord) -> Promise<(CKRecord, CKRecord)>
    func remove(userRecord: CKRecord, from teamRecord: CKRecord) -> Promise<CKRecord>

    func save(_ records: [CKRecord]) -> Promise<[CKRecord]>

    func save(_ subscripitions: [CKSubscription], andRemove subscriptionsToRemove: [CKSubscription.ID]?) -> Promise<Bool>
    func subscriptionForUpdates(recordType: CKRecord.RecordType, objectUUID: String) -> CKQuerySubscription
    func removeSubscriptions() -> Promise<Bool>
}

