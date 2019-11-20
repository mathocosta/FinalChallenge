//
//  AchievementsViewController.swift
//  Movinning
//
//  Created by Thalia Freitas on 20/11/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import Foundation
import UIKit

class AchievementsViewController: UIViewController, LoaderView {
    var loadingView: LoadingView = {
        let view = LoadingView()
        return view
    }()

    weak var coordinator: AchievementsTabCoordinator?

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}
