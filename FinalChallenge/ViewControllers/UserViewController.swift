//
//  UserViewController.swift
//  FinalChallenge
//
//  Created by Martônio Júnior on 03/09/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit
import CoreData

class UserViewController: UIViewController {
    var loggedUser: User!
    override func viewDidLoad() {
        super.viewDidLoad()
        getLoggedUser()
    }

    func getLoggedUser() {
        let request = NSFetchRequest<User>()
        let users = CoreDataManager.fetch(request)
        if users.count > 0 {
            loggedUser = users.first
        } else {
            let user = User()
            user.id = UUID()
            user.name = "User"
            user.email = "user@app.com"
            user.points = 0
            user.goalPile = []
            CoreDataManager.saveContext()
        }
    }

    func displayAmountOfPoints() {
        print(loggedUser.points)
    }

    func updateUser(addPoints points: Int) {
        loggedUser.points += Int32(points)
        CoreDataManager.saveContext()
        displayAmountOfPoints()
    }

}
