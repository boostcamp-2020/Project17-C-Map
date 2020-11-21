//
//  CoreDataStack.swift
//  InteractiveClusteringMap
//
//  Created by A on 2020/11/21.
//

import Foundation
import CoreData

final class CoreDataStack {

    static let container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print(error.localizedDescription)
            }
        })
        return container
    }()
    
    static let context: NSManagedObjectContext = container.viewContext

    // MARK: - Core Data Saving support

    static func saveContext () {
       
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    private init() { }
    
}
