//
//  CKUserInformationOperation.swift
//  FinalChallenge
//
//  Created by Matheus Oliveira Costa on 14/09/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import CloudKit

// FIXME: Essa operation tá muito mal escrita, fiz em cima da hora :)
// Ela precisa ter mais cuidado se as coisas estão sendo executadas e onde estão sendo chamadas
// os completion blocks. Não tem nenhuma prevenção aos erros que podem aparecer e a completionBlock é
// chamada sem servir de nada.
class CKUserInformationOperation: CKOperation {

    override var isAsynchronous: Bool {
        return true
    }

    var userInformationCompletionBlock: ((CKRecord?, CKUserIdentity?) -> Void)?

    override func main() {
        guard let container = configuration.container else { return }
        container.fetchUserRecordID(completionHandler: { (userRecordID, error) in
            guard let userRecordID = userRecordID else {
                if let completionBlock = self.completionBlock,
                    let userInformationCompletionBlock = self.userInformationCompletionBlock {
                    userInformationCompletionBlock(nil, nil)
                    completionBlock()
                }
                return
            }

            container.privateCloudDatabase.fetch(withRecordID: userRecordID) { userRecord, _ in
                container.discoverUserIdentity(withUserRecordID: userRecordID) { userIdentity, _ in
                    if let completionBlock = self.completionBlock,
                       let userInformationCompletionBlock = self.userInformationCompletionBlock {
                        userInformationCompletionBlock(userRecord, userIdentity)
                        completionBlock()
                    }
                }
            }
        })
    }
}


