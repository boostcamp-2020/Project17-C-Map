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
    
    func fetch() -> [POI] {
        do {
            let entity = try context.fetch(POIEntity.fetchRequest()) as [POIEntity]
            var pois: [POI] = []
            
            entity.forEach {
                pois.append(POI(x: $0.x, y: $0.y, id: $0.id, name: $0.name, imageUrl: $0.imageUrl, category: $0.category))
            }
            return pois
        } catch {
            return []
        }
    }
    
    func setValue(_ poi: POI) {
        let entity = NSEntityDescription.entity(forEntityName: "POIEntity", in: context)
        if let entity = entity {
            let value = NSManagedObject(entity: entity, insertInto: context)
            value.setValue(poi.x, forKey: "x")
            value.setValue(poi.y, forKey: "y")
            value.setValue(poi.id, forKey: "id")
            value.setValue(poi.name, forKey: "name")
            value.setValue(poi.imageUrl, forKey: "imageUrl")
            value.setValue(poi.category, forKey: "category")
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
