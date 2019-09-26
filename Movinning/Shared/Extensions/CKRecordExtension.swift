//
//  CKRecordExtension.swift
//  FinalChallenge
//
//  Created by Matheus Oliveira Costa on 14/09/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import Foundation
import CloudKit

extension CKRecord {

    convenience init?(recordMetadata: Data) {
        guard let coder = try? NSKeyedUnarchiver(forReadingFrom: recordMetadata) else {
            return nil
        }
        coder.requiresSecureCoding = true
        self.init(coder: coder)
        coder.finishDecoding()
    }

    /// Transforma as chaves padrões (metadata) de um CKRecord para Data
    func recordMetadata() -> Data {
        let coder = NSKeyedArchiver(requiringSecureCoding: true)
        encodeSystemFields(with: coder)

        return coder.encodedData
    }

    /// Obtém as chaves e os valores na forma de um dicionário [String, Any?]
    func recordKeysAndValues() -> [String: Any?] {
        var dict = [String: Any?]()
        for key in allKeys() {
            let currentValue = value(forKey: key)

            if let asset = currentValue as? CKAsset {
                dict[key] = data(from: asset)
            } else {
                dict[key] = currentValue
            }
        }

        dict["recordMetadata"] = recordMetadata()

        return dict
    }

    /// Transforma um asset para Data
    private func data(from ckAsset: CKAsset) -> Data {
        var assetData = Data()
        if let fileURL = ckAsset.fileURL {
            do {
                assetData = try Data(contentsOf: fileURL)
            } catch {
                print(error.localizedDescription)
            }
        }
        return assetData
    }
}
