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
    static let defaults = UserDefaults()
    var window: UIWindow?

    private var appCoordinator: AppCoordinator?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        let healthStoreManager = HealthStoreManager()
        healthStoreManager.requestAuthorization { (success) in
            print("HealthKit authored: \(success)")
        }

        guard let stepCountType = HKObjectType.quantityType(forIdentifier: .stepCount) else { return true }
        healthStoreManager.quantitySum(of: stepCountType) { (result) in
            switch result {
            case .success(let statistics):
                if let quantity = statistics.sumQuantity() {
                    print(quantity.doubleValue(for: HKUnit.count()))
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }

        let navigationController = UINavigationController()
        appCoordinator = AppCoordinator(navigationController: navigationController)

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
