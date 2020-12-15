//
//  CoreDataStack.swift
//  InteractiveClusteringMap
//
//  Created by A on 2020/11/21.
//

import UIKit
import CoreData

final class CoreDataStack: DataManagable {
    
    static let shared: CoreDataStack = CoreDataStack()
    
    private weak var appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
    private lazy var container: NSPersistentContainer? = appDelegate?.container
    private lazy var context: NSManagedObjectContext? = container?.viewContext
    
    private let fileName: String = "restuarant-list-for-test"
    
    private init() {
        let pois = JSONReader.readPOIs(fileName: fileName)
        pois?.forEach {
            setValue($0)
        }
        pois?.forEach {
            setValue($0)
        }
        pois?.forEach {
            setValue($0)
        }
        pois?.forEach {
            setValue($0)
        }
        pois?.forEach {
            setValue($0)
        }
        pois?.forEach {
            setValue($0)
        }
        pois?.forEach {
            setValue($0)
        }
        pois?.forEach {
            setValue($0)
        }
        pois?.forEach {
            setValue($0)
        }
        pois?.forEach {
            setValue($0)
        }
    }
    
    func deleteAll() {
        guard let container = container else { return }
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: POIEntity.name)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try container.persistentStoreCoordinator.execute(deleteRequest, with: container.viewContext)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func fetch() -> [POIEntity] {
        guard let context = context,
              let entities = try? context.fetch(POIEntity.fetchRequest()) as? [POIEntity]
        else {
            return []
        }
        
        return entities
    }
    
    func setValue(_ poi: POI) {
        guard let context = context else { return }
        
        let entity = NSEntityDescription.entity(forEntityName: POIEntity.name, in: context)
        if let entity = entity {
            let value = NSManagedObject(entity: entity, insertInto: context)
            value.setValue(poi.x, forKey: POI.Name.x)
            value.setValue(poi.y, forKey: POI.Name.y)
            value.setValue(poi.id, forKey: POI.Name.id)
            value.setValue(poi.name, forKey: POI.Name.name)
            value.setValue(poi.imageUrl, forKey: POI.Name.imageUrl)
            value.setValue(poi.category, forKey: POI.Name.category)
        }
    }
    
    func save(successHandler: (() -> Void)?, failureHandler: ((NSError) -> Void)? = nil) {
        guard let context = context else { return }

        if context.hasChanges {
            do {
                try context.save()
                successHandler?()
            } catch {
                let nsError = error as NSError
                failureHandler?(nsError)
            }
        }
    }
    
}
