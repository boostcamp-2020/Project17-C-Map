//
//  CoreDataStack.swift
//  InteractiveClusteringMap
//
//  Created by A on 2020/11/21.
//

import UIKit
import CoreData

final class CoreDataStack: DataManagable {
    
    private enum Name {
        static let fileName: String = "restuarant-list-for-test"
        static let queueName: String = "CoreDataStackQueue"
    }
    
    static let shared: CoreDataStack = CoreDataStack()
    
    private weak var appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
    private lazy var container: NSPersistentContainer? = appDelegate?.container
    private lazy var context: NSManagedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
    
    private init() {
        context.parent = container?.viewContext
        
        guard let pois = try? context.fetch(POIMO.fetchRequest()),
              pois.count != 0 else {
            let pois = JSONReader.readPOIs(fileName: Name.fileName)
            pois?.forEach {
                setValue($0)
            }
            return
        }
    }
    
    func deleteAll() {
        do {
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: POIMO.fetchRequest())
            try context.execute(deleteRequest)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        save(successHandler: nil)
    }
    
    func delete(coordinate: Coordinate) {
        let request = POIMO.fetchRequest(coordinate: coordinate)
        guard let objects = try? context.fetch(request) else {
            return
        }
        objects.forEach {
            context.delete($0)
        }
        save(successHandler: nil)
    }
    
    func add(coordinate: Coordinate) {
        setValue(POI(x: coordinate.x, y: coordinate.y, id: coordinate.id, name: "", imageUrl: "", category: ""))
        save(successHandler: nil)
    }
    
    func update(poi: POI) {
        let request = POIMO.fetchRequest(coordinate: Coordinate(x: poi.x, y: poi.y, id: poi.id))
        guard let objects = try? context.fetch(request) else {
            return
        }
        objects.first?.update(poi)
        save(successHandler: nil)
    }
    
    func fetch() -> [POIMO] {
        let request: NSFetchRequest<POIMO> = POIMO.fetchRequest()
        guard let entities = try? context.fetch(request) else {
            return []
        }
        return entities
    }
    
    func fetch(handler: @escaping ([POIMO]) -> Void) {
        context.perform { [weak self] in
            let request: NSFetchRequest<POIMO> = POIMO.fetchRequest()
            guard let self = self,
                  let entities = try? self.context.fetch(request) else {
                DispatchQueue.main.async {
                    handler([])
                }
                return
            }
            DispatchQueue.main.async {
                handler(entities)
            }
        }
    }
    
    func fetch(coordinate: Coordinate) -> [POIMO] {
        let request = POIMO.fetchRequest(coordinate: coordinate)
        guard let entities = try? context.fetch(request) else {
            return []
        }
        return entities
    }
    
    func fetch(coordinate: Coordinate, handler: @escaping ([POIMO]) -> Void) {
        context.perform { [weak self] in
            let request = POIMO.fetchRequest(coordinate: coordinate)
            guard let self = self,
                  let entities = try? self.context.fetch(request) else {
                DispatchQueue.main.async {
                    handler([])
                }
                return
            }
            DispatchQueue.main.async {
                handler(entities)
            }
        }
    }
    
    func fetch(bottomLeft: Coordinate, topRight: Coordinate) -> [POIMO] {
        let fetchRequest = POIMO.fetchRequest(bottomLeft: bottomLeft, topRight: topRight)
        guard let entities = try? context.fetch(fetchRequest) else {
            return []
        }
        return entities
    }
    
    func fetch(bottomLeft: Coordinate, topRight: Coordinate, handler: @escaping ([POIMO]) -> Void) {
        context.perform { [weak self] in
            let request = POIMO.fetchRequest(bottomLeft: bottomLeft, topRight: topRight)
            guard let self = self,
                  let entities = try? self.context.fetch(request) else {
                DispatchQueue.main.async {
                    handler([])
                }
                return
            }
            DispatchQueue.main.async {
                handler(entities)
            }
        }
    }
    
    func fetch(coordinates: [Coordinate]) -> [POIInfoMO] {
        let predicates = coordinates.map { NSPredicate(format: "id == %d", $0.id) }
        let compoundPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: predicates)
        let request: NSFetchRequest<POIMO> = POIMO.fetchRequest()
        request.predicate = compoundPredicate
        
        guard let entities = try? context.fetch(request) else {
            return []
        }
        
        return entities.compactMap { $0.info }
    }
    
    func fetch(coordinate: Coordinate) -> POIInfoMO? {
        let predicate = NSPredicate(format: "id == %d", coordinate.id)
        let request: NSFetchRequest<POIMO> = POIMO.fetchRequest()
        request.predicate = predicate
        
        guard let entity = try? context.fetch(request) else {
            return nil
        }
        
        return entity.first?.info
    }
    
    func setValue(_ poi: POI) {
        guard let poiMO = NSEntityDescription.insertNewObject(forEntityName: POIMO.name, into: context) as? POIMO,
              let infoMO = NSEntityDescription.insertNewObject(forEntityName: POIInfoMO.name, into: context) as? POIInfoMO else {
            return
        }
        infoMO.setValues(POIInfo(name: poi.name, imageUrl: poi.imageUrl, category: poi.category))
        poiMO.setValues(coordinate: Coordinate(x: poi.x, y: poi.y, id: poi.id), info: infoMO)
    }
    
    func save(successHandler: (() -> Void)?, failureHandler: ((NSError) -> Void)? = nil) {
        context.performAndWait {
            guard context.hasChanges else {
                return
            }
            do {
                try context.save()
                try container?.viewContext.save()
                successHandler?()
            } catch {
                let nsError = error as NSError
                failureHandler?(nsError)
            }
        }
    }
    
}
