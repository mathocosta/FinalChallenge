//
//  AppDelegate.swift
//  FinalChallenge
//
//  Created by Matheus Oliveira Costa on 02/09/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit
import CoreData
import HealthKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    private var appCoordinator: AppCoordinator?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        let healthStoreManager = HealthStoreManager()
        healthStoreManager.requestAuthorization { (result) in
            switch result {
            case .success(let isAuthorized):
                print("HealthKit authored: \(isAuthorized)")
            case .failure(let error):
                print(error)
            }
        }

        appCoordinator = AppCoordinator(tabBarController: UITabBarController())

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = appCoordinator?.rootViewController
        appCoordinator?.start()

        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        CoreDataManager.saveContext()
    }

}
