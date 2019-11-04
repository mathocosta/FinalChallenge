//
//  UserPreferencesViewController+Delegate+DataSource.swift
//  Movinning
//
//  Created by Martônio Júnior on 01/11/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit

extension UserPreferencesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sports.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = preferencesView.tableView.dequeueReusableCell(
            withIdentifier: "UserPreferencesCollectionViewCell", for: indexPath) as? UserPreferencesTableViewCell else {
            return UITableViewCell()
        }
        let sport = sports[indexPath.row]
        cell.sport = sport
        cell.toggled = selectedSports.contains(sport)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = preferencesView.tableView.dequeueReusableCell(
            withIdentifier: "UserPreferencesCollectionViewCell", for: indexPath)
            as? UserPreferencesTableViewCell else { return }
        let sport = sports[indexPath.row]
        cell.toggled = !cell.toggled
        if cell.toggled {
            selectedSports.append(sport)
        } else {
            selectedSports.removeAll(where: { return $0 == sport })
        }
        preferencesView.tableView.reloadRows(at: [indexPath], with: .fade)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {

    }
}
