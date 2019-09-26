//
//  UIAlertController+DefaultTypes.swift
//  FinalChallenge
//
//  Created by Martônio Júnior on 03/09/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit

extension UIAlertController {
    static func okAlert(title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okAction)
        return alert
    }
}
