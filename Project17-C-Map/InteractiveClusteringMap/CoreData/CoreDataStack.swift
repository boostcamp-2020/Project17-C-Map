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
    private lazy var context: NSManagedObjectContext? = container?.viewContext
    
    private let queue: DispatchQueue = .init(label: Name.queueName, qos: .background, attributes: .concurrent)
    
    private init() {
        let pois = JSONReader.readPOIs(fileName: Name.fileName)
        pois?.forEach {
            setValue($0)
        }
    }
    
    func deleteAll() {
        guard let container = container else { return }
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: POIMO.fetchRequest())
        
        do {
            try container.persistentStoreCoordinator.execute(deleteRequest, with: container.viewContext)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func fetch() -> [POICoordinateMO] {
        guard let context = context,
              let entities = try? context.fetch(POICoordinateMO.fetchRequest()) as? [POICoordinateMO]
        else {
            return []
        }
        return entities
    }
    
    func fetchAsync(handler: @escaping ([POICoordinateMO]) -> Void) {
        queue.async { [weak self] in
            guard let self = self,
                  let context = self.context,
                  let entities = try? context.fetch(POICoordinateMO.fetchRequest()) as? [POICoordinateMO]
            else {
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
    
    func fetch(topLeft: Coordinate, bottomRight: Coordinate) -> [POICoordinateMO] {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = POICoordinateMO.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "lng >= %@ AND lng <= %@ AND lat >= %@ AND lat <= %@",
                                             topLeft.x, bottomRight.x, bottomRight.y, topLeft.y)
        guard let context = context,
              let entities = try? context.fetch(fetchRequest) as? [POICoordinateMO]
        else {
            return []
        }
        
        return entities
    }
    
    func fetchAsync(topLeft: Coordinate, bottomRight: Coordinate, handler: @escaping ([POICoordinateMO]) -> Void) {
        queue.async { [weak self] in
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = POICoordinateMO.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "lng >= %@ AND lng <= %@ AND lat >= %@ AND lat <= %@",
                                                 topLeft.x, bottomRight.x, bottomRight.y, topLeft.y)
            guard let self = self,
                  let context = self.context,
                  let entities = try? context.fetch(fetchRequest) as? [POICoordinateMO]
            else {
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
    
    func setValue(_ poi: POI) {
        guard let context = context else { return }
        
        guard let poiMO = NSEntityDescription.insertNewObject(forEntityName: POIMO.name, into: context) as? POIMO,
              let coordMO = NSEntityDescription.insertNewObject(forEntityName: POICoordinateMO.name, into: context) as? POICoordinateMO,
              let infoMO = NSEntityDescription.insertNewObject(forEntityName: POIInfoMO.name, into: context) as? POIInfoMO else {
            return
        }
        poiMO.setValues(id: poi.id, coordinate: coordMO, info: infoMO)
        coordMO.setValues(Coordinate(x: poi.x, y: poi.y))
        infoMO.setValues(POIInfo(name: poi.name, imageUrl: poi.imageUrl, category: poi.category))
    }
    
    func save(successHandler: (() -> Void)?, failureHandler: ((NSError) -> Void)? = nil) {
        guard let context = context else { return }
        try? context.save()
        
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
