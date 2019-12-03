//
//  String+Capitalization.swift
//  Movinning
//
//  Created by Martônio Júnior on 21/11/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import Foundation

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
