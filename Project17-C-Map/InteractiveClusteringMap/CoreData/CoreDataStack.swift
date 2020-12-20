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
        
        context.perform { [weak self] in
            guard let poiCount = try? self?.container?.viewContext.count(for: POIMO.fetchRequest()),
                  poiCount != 0 else {
                let pois = JSONReader.readPOIs(fileName: Name.fileName)
                pois?.forEach {
                    self?.setValue($0)
                }
                return
            }
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
        guard let request = POIMO.fetchRequest(coordinate: coordinate),
              let objects = try? context.fetch(request)
        else {
            return
        }
        objects.forEach {
            context.delete($0)
        }
        save(successHandler: nil)
    }
    
    func add(poi: POI) {
        setValue(poi)
        save(successHandler: nil)
    }
    
    func update(poi: POI) {
        guard let request = POIMO.fetchRequest(coordinate: Coordinate(x: poi.x, y: poi.y, id: poi.id)),
              let objects = try? context.fetch(request)
        else {
            return
        }
        objects.first?.update(poi)
        save(successHandler: nil)
    }
    
    func fetch(coordinate: Coordinate) -> [POIMO] {
        guard let request = POIMO.fetchRequest(coordinate: coordinate),
              let entities = try? context.fetch(request)
        else {
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
    
    private func setValue(_ poi: POI) {
        guard let poiMO = NSEntityDescription.insertNewObject(forEntityName: POIMO.name, into: context) as? POIMO,
              let infoMO = NSEntityDescription.insertNewObject(forEntityName: POIInfoMO.name, into: context) as? POIInfoMO else {
            return
        }
        infoMO.setValues(POIInfo(name: poi.name, imageUrl: poi.imageUrl, category: poi.category))
        poiMO.setValues(coordinate: Coordinate(x: poi.x, y: poi.y, id: poi.id), info: infoMO)
    }
    
}
