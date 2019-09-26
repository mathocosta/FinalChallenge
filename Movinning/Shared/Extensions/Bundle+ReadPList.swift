//
//  Bundle+ReadPList.swift
//  FinalChallenge
//
//  Created by Martônio Júnior on 06/09/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import Foundation

extension Bundle {
    func contentsOfPList(fileName: String) -> [String: AnyObject] {
        guard let path = Bundle.main.path(forResource: fileName, ofType: "plist"),
            let contents = NSDictionary(contentsOfFile: path) as? [String: AnyObject]
            else { return [:] }
        return contents
    }
}
