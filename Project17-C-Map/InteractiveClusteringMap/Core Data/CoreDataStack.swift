//
//  CoreDataStack.swift
//  InteractiveClusteringMap
//
//  Created by A on 2020/11/21.
//

import Foundation
import CoreData

final class CoreDataStack: DataManagable {
    
    static let shared: CoreDataStack = CoreDataStack()
    
    private lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print(error.localizedDescription)
            }
        })
        return container
    }()
    
    private lazy var context: NSManagedObjectContext = container.viewContext
    
    private init() { }
    
    func fetch() -> [POI]? {
        do {
            return try context.fetch(POI.fetchRequest()) as [POI]
        } catch {
            return []
        }
    }
    
    func setValue() {
        let entity = NSEntityDescription.entity(forEntityName: "POI", in: context)
        
        if let entity = entity {
            let poi = NSManagedObject(entity: entity, insertInto: context)
            poi.setValue(30.173648, forKey: "x")
            poi.setValue(120.182837, forKey: "y")
            let poi2 = NSManagedObject(entity: entity, insertInto: context)
            poi2.setValue(33.3178, forKey: "x")
            poi2.setValue(127.782837, forKey: "y")
        }
    }
    
    func save(successHandler: @escaping () -> Void, failureHandler: ((NSError) -> Void)? = nil) {
        if context.hasChanges {
            do {
                try context.save()
                successHandler()
            } catch {
                let nsError = error as NSError
                failureHandler?(nsError)
            }
        }
    }
    
}
