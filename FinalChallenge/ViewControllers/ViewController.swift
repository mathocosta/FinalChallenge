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
        let user = UserManager.getLoggedUser()
        if user.goalPile == nil {
            user.goalPile = GoalPile(value: [])
            CoreDataManager.saveContext()
        }
        print("\(GoalsManager.amountOfGoals()) goals")
        GoalsManager.setNewTimedGoals(for: user)
        GoalsManager.removeTimedGoals(from: user)

        let manager = HealthStoreManager()

        manager.quantitySumSinceLastUpdate(of: .stepCount) { (result) in
            switch result {
            case .success(let statistics):
                if let quantity = statistics.sumQuantity() {
                    let pointsGained = PointManager.points(forSteps: quantity.doubleValue(for: .count()))
                    UserManager.update(UserManager.current.loggedUser, addPoints: pointsGained)
                    var message = "Points gained since "
                    message += "last time: \(pointsGained) "
                    message += "Current Total: \(UserManager.current.loggedUser.points)"
                    self.displayOKAlert(title: "Update", message: message)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    func displayOKAlert(title: String, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController.okAlert(title: title, message: message)
            self.present(alert, animated: true, completion: nil)
        }
    }
}
