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
    
    private let containerName: String = "Model"
    
    private lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                print(error.localizedDescription)
            }
        })
        return container
    }()
    
    private lazy var context: NSManagedObjectContext = container.viewContext
    
    private init() { }
    
    func deleteAll() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "POIEntity")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try container.persistentStoreCoordinator.execute(deleteRequest, with: context)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func fetch() -> [POIEntity] {
        guard let entities = try? context.fetch(POIEntity.fetchRequest()) as? [POIEntity] else {
            return []
        }
        return entities
    }
    
    func setValue(_ poi: POI) {
        let entity = NSEntityDescription.entity(forEntityName: POIEntity.name, in: context)
        if let entity = entity {
            let value = NSManagedObject(entity: entity, insertInto: context)
            value.setValue(poi.x, forKey: POI.Name.x.rawValue)
            value.setValue(poi.y, forKey: POI.Name.y.rawValue)
            value.setValue(poi.id, forKey: POI.Name.id.rawValue)
            value.setValue(poi.name, forKey: POI.Name.name.rawValue)
            value.setValue(poi.imageUrl, forKey: POI.Name.imageUrl.rawValue)
            value.setValue(poi.category, forKey: POI.Name.category.rawValue)
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
