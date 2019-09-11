//
//  ViewController.swift
//  FinalChallenge
//
//  Created by Matheus Oliveira Costa on 02/09/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func loadView() {
        view = FirstView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let user = UserManager.current.loggedUser else { return }
        GoalsManager.checkForCompletedGoals(for: user)
    }

    func displayOKAlert(title: String, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController.okAlert(title: title, message: message)
            self.present(alert, animated: true, completion: nil)
        }
    }
}
