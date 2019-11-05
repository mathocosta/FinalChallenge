//
//  UserPreferencesViewController+Delegate+DataSource.swift
//  Movinning
//
//  Created by Martônio Júnior on 01/11/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit

extension UserPreferencesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sports.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = preferencesView.collectionView.dequeueReusableCell(
            withReuseIdentifier: "UserPreferencesCollectionViewCell",
            for: indexPath) as? UserPreferencesCollectionViewCell else {
            return UICollectionViewCell()
        }
        let sport = sports[indexPath.row]
        cell.sport = sport
        cell.toggled = selectedSports.contains(sport)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = preferencesView.collectionView.dequeueReusableCell(
            withReuseIdentifier: "UserPreferencesCollectionViewCell", for: indexPath)
            as? UserPreferencesCollectionViewCell else { return }
        let sport = sports[indexPath.row]
        cell.toggled = !selectedSports.contains(sport)
        if cell.toggled {
            selectedSports.append(sport)
        } else {
            selectedSports.removeAll(where: { return $0 == sport })
        }
        preferencesView.collectionView.reloadItems(at: [indexPath])
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: preferencesView.collectionView.frame.height / 2.1, height: 50)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {

    }
}
