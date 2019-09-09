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
        var pile: [Int]? = [Int]()
        print("\(GoalsManager.amountOfGoals()) goals")
        for _ in 0...10 {
            var newGoals = GoalsManager.getGoals(withIDs: (GoalsManager.selectNewTimedGoals(fromPile: pile!)))
            var txt = "Shuffle: "
            for goal in newGoals {
                txt += "\(goal.id) "
            }
            print(txt)
            GoalsManager.removeTimedGoals(timedGoals: &newGoals, sendToPile: &pile)
        }
    }

}
