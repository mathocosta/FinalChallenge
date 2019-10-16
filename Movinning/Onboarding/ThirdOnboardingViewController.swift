//
//  ThirdOnboardingViewController.swift
//  Movinning
//
//  Created by Thalia Freitas on 16/10/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit

class ThirdOnboardingViewController: UIViewController {

    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.backgroundColor
            
            // label
            let labelInst = UILabel()
            let labelDescription = UILabel()
            self.view.addSubview(labelInst)
            
            labelInst.text = "Complete"
            labelInst.translatesAutoresizingMaskIntoConstraints = false
            labelInst.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100).isActive = true
            labelInst.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
            self.view.addSubview(labelDescription)
            labelDescription.text = "Registration Kitjhdhjkhfjkshdkjfhjksdhkjfhskjdh"
            labelDescription.translatesAutoresizingMaskIntoConstraints = false
            labelDescription.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100).isActive = true
            labelDescription.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 200).isActive = true
        }

        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
}
