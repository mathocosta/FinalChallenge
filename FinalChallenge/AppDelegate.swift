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

        // TODO: Remover isso depois, foi feito rápido para colocar no testflight :P
        if UserDefaults.standard.value(forKey: "SeedTeams") == nil {
            seedCoreData()
            UserDefaults.standard.set(true, forKey: "SeedTeams")
        }

        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        CoreDataManager.saveContext()
    }

    // TODO: Remover isso depois, foi feito rápido para colocar no testflight :P
    func seedCoreData() {
        let team1 = Team(context: CoreDataManager.context)
        team1.id = UUID()
        team1.name = "Fortaleza"
        team1.points = 0

        let team2 = Team(context: CoreDataManager.context)
        team2.id = UUID()
        team2.name = "Ceará"
        team2.points = 0

        let team3 = Team(context: CoreDataManager.context)
        team3.id = UUID()
        team3.name = "Ferroviário"
        team3.points = 0

        CoreDataManager.saveContext()
    }

}
