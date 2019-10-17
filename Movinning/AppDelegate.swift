//
//  AppDelegate.swift
//  FinalChallenge
//
//  Created by Matheus Oliveira Costa on 02/09/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit
import CoreData
import CloudKit
import HealthKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    private var appCoordinator: AppCoordinator?

    // MARK: - Application Lifecycle
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        // Checa se o usuário não está logado, por agora, isso quer dizer que é
        // o primeiro acesso ao app
        UserDefaults.standard.isFirstLogin = UserManager.getLoggedUser() == nil

        // Adiciona as subscriptions caso não existam
        if !application.isRegisteredForRemoteNotifications {
            application.registerForRemoteNotifications()
        }

        appCoordinator = AppCoordinator(tabBarController: UITabBarController())

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = appCoordinator?.rootViewController
        window?.backgroundColor = .backgroundColor
        appCoordinator?.start()

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        CoreDataStore.saveContext()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        let now = Date()
        let calendar = Calendar(identifier: .gregorian)

        guard let user = UserManager.getLoggedUser() else { return }

        guard let lastUpdateTime = UserDefaults.standard.goalUpdateTime,
            let nextUpdateTime = calendar.getNextUpdateTime(from: lastUpdateTime) else {
                UserManager.changeGoals(for: user)
                return
        }

        if nextUpdateTime.compare(now) == .orderedAscending {
            UserManager.changeGoals(for: user, at: now)
        } else {

            GoalsManager.checkForCompletedGoals(for: user)
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        CoreDataStore.saveContext()
    }

    // MARK: - Remote Notifications
    func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable: Any],
        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
    ) {
        if let notification = CKQueryNotification(fromRemoteNotificationDictionary: userInfo) {
            if notification.category == "team-update" {
                if let loggedUser = UserManager.getLoggedUser() {
                    SessionManager.current.updateLocallyTeam(of: loggedUser) { (result) in
                        if case .failure(let error) = result {
                            print(error.localizedDescription)
                            completionHandler(.failed)
                        } else {
                            completionHandler(.newData)
                        }
                    }
                }
            }
        }
    }

}
