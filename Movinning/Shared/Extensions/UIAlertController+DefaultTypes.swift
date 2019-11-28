//
//  UIAlertController+DefaultTypes.swift
//  FinalChallenge
//
//  Created by Martônio Júnior on 03/09/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit

extension UIAlertController {
    static func okAlert(title: String, message: String, whenDismiss: (() -> Void)? = nil) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        alert.addAction(UIAlertAction(
            title: NSLocalizedString("OK", comment: "Default Action"),
            style: .default,
            handler: { _ in
                alert.dismiss(animated: true, completion: whenDismiss)
            }
        ))

        return alert
    }

    static func cancelAlert(title: String, message: String, whenConfirm: (() -> Void)? = nil) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        alert.addAction(UIAlertAction(
            title: NSLocalizedString("OK", comment: "Default Action"),
            style: .default,
            handler: { _ in
                alert.dismiss(animated: true, completion: whenConfirm)
            }
        ))
        alert.addAction(UIAlertAction(
            title: NSLocalizedString("Cancel", comment: "Default Action"),
            style: .destructive,
            handler: { _ in
                alert.dismiss(animated: true, completion: nil)
            }
        ))

        return alert
    }
}
