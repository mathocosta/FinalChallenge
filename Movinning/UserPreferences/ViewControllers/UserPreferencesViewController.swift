//
//  UserPreferencesViewController.swift
//  Movinning
//
//  Created by Martônio Júnior on 01/11/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit

class UserPreferencesViewController: UIViewController {
    var sports: [Any] = []

    // MARK: - Properties
    var preferencesView: UserPreferencesView = {
        let view = UserPreferencesView()
        return view
    }()
    
    // MARK: - Lifecycle
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        preferencesView.collectionView.delegate = self
        preferencesView.collectionView.dataSource = self
        preferencesView.collectionView.register(UserPreferencesCollectionViewCell.self,
                                                forCellWithReuseIdentifier: "UserPreferencesCollectionViewCell")
    }
}
