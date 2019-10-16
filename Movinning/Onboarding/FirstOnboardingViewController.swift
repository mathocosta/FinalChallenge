//
//  FirstOnboardingViewController.swift
//  Movinning
//
//  Created by Thalia Freitas on 16/10/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit

class FirstOnboardingViewController: UIViewController {
    let labelTitle = UILabel()
    let labelDescription = UILabel()
    let imageBoard = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
            
            self.view.backgroundColor = UIColor.backgroundColor
            self.view.addSubview(labelTitle)
            labelTitle.text = "Healthy Kit"
            self.view.addSubview(labelDescription)
            labelDescription.text = "Healthy Kitjhdhjkhfjkshdkjfhjksdhkjfhskjdh"
            self.view.addSubview(imageBoard)
            labelTitle.translatesAutoresizingMaskIntoConstraints = false
            labelTitle.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 50).isActive = true
            labelTitle.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
            labelDescription.translatesAutoresizingMaskIntoConstraints = false
            labelDescription.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100).isActive = true
            labelDescription.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
            imageBoard.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100).isActive = true
        }
    
    func setupConstraints() {
        labelTitle.translatesAutoresizingMaskIntoConstraints = false
        labelTitle.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 50).isActive = true
        labelTitle.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        labelDescription.translatesAutoresizingMaskIntoConstraints = false
        labelDescription.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100).isActive = true
        labelDescription.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true

    }

        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }

}
