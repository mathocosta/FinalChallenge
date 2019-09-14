//
//  CoreStataStore.swift
//  FinalChallenge
//
//  Created by Matheus Oliveira Costa on 02/09/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import Foundation
import CoreData

class CoreStataStore: NSObject {
    static var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "FinalChallenge")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    static func fetch<T>(_ request: NSFetchRequest<T>) -> [T] {
        do {
            let list = try persistentContainer.viewContext.fetch(request)
            return list
        } catch {
            print(error)
            return [T]()
        }
    }

    static var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    static func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
                print("Context Saved")
            } catch {
                let nserror = error as NSError
                print("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
