//
//  UserPreferencesViewController+Delegate+DataSource.swift
//  Movinning
//
//  Created by Martônio Júnior on 01/11/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit

extension UserPreferencesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sports.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = preferencesView.collectionView.dequeueReusableCell(withReuseIdentifier: "UserPreferencesCollectionViewCell", for: indexPath) as? UserPreferencesCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.sportText = "Sport"
    }
    
    
}
