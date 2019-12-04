//
//  UIViewController+Alert.swift
//  Movinning
//
//  Created by Paulo José on 29/10/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit

extension UIViewController {

    func presentAlert(with alertTitle: String,
                      message: String,
                      completion: @escaping (() -> Void),
                      cancel: (() -> Void)? = nil) {
        let alert = UIAlertController(title: alertTitle, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default) { (_) in
            completion()
            alert.dismiss(animated: true, completion: nil)
        }

        if (cancel != nil) {
            let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .destructive) { (_) in
                cancel?()
            }
            alert.addAction(cancelAction)
        }

        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
