//
//  CKManagedObject.swift
//  FinalChallenge
//
//  Created by Matheus Oliveira Costa on 04/09/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit
import CoreData
import CloudKit

protocol CKManagedObject {
    var entityName: String { get }

    func asCKRecord() -> CKRecord
}

extension CKManagedObject where Self: NSManagedObject {
    var entityName: String {
        return entity.name ?? ""
    }
}

extension CKManagedObject {

    /// Cria um `CKAsset` para uma `UIImage`. Para isso, cria um arquivo temporário no disco para
    /// criar uma URL necessário no construtor do `CKAsset`.
    ///
    /// - Parameter image: imagem para ser transformada
    /// - Returns: imagem convertida para `CKAsset`
    func ckAsset(of image: UIImage) -> CKAsset {
        let data = image.pngData()
        let url = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(UUID().uuidString + ".dat")

        do {
            try data?.write(to: url)
        } catch let error {
            print(error)
        }

        return CKAsset(fileURL: url)
    }

}
