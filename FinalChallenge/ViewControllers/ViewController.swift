//
//  ViewController.swift
//  FinalChallenge
//
//  Created by Matheus Oliveira Costa on 02/09/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    override func loadView() {
        view = FirstView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        UserManager.current.simulateAppInteraction()
    }
}
