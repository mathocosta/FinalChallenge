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
        if user.team == nil, let team = TeamManager.allTeams().first {
            TeamManager.add(user, to: team)
            seedUsers(into: team)
        }
        GoalsManager.checkForCompletedGoals(for: user)
    }
    
    func seedUsers(into team: Team) {
        let userNames = ["marcos","juliana","luiz","andré","paula"]
        for name in userNames {
            let user = UserManager.createNewUser(name: name, email: name+"@gmail.com")
            user.points = Int32.random(in: 0...500)
            TeamManager.add(user, to: team)
            CoreDataManager.saveContext()
        }
    }

    func displayOKAlert(title: String, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController.okAlert(title: title, message: message)
            self.present(alert, animated: true, completion: nil)
        }
    }
}
