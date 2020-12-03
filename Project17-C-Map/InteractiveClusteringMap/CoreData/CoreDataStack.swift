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
        
        let pois = JSONReader.readPOIs(fileName: Name.fileName)
        pois?.forEach {
            setValue($0)
        }
    }
    
    func deleteAll() {
        do {
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: POIMO.fetchRequest())
            try context.execute(deleteRequest)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func fetch(handler: @escaping ([POICoordinateMO]) -> Void) {
        context.perform { [weak self] in
            let request: NSFetchRequest<POICoordinateMO> = POICoordinateMO.fetchRequest()
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
    
    func fetch(bottomLeft: Coordinate, topRight: Coordinate, handler: @escaping ([POICoordinateMO]) -> Void) {
        context.perform { [weak self] in
            let request = POICoordinateMO.fetchRequest(bottomLeft: bottomLeft, topRight: topRight)
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
    
    func setValue(_ poi: POI) {
        guard let poiMO = NSEntityDescription.insertNewObject(forEntityName: POIMO.name, into: context) as? POIMO,
              let coordMO = NSEntityDescription.insertNewObject(forEntityName: POICoordinateMO.name, into: context) as? POICoordinateMO,
              let infoMO = NSEntityDescription.insertNewObject(forEntityName: POIInfoMO.name, into: context) as? POIInfoMO else {
            return
        }
        coordMO.setValues(Coordinate(x: poi.x, y: poi.y))
        infoMO.setValues(POIInfo(name: poi.name, imageUrl: poi.imageUrl, category: poi.category))
        poiMO.setValues(id: poi.id, coordinate: coordMO, info: infoMO)
    }
    
    func save(successHandler: (() -> Void)?, failureHandler: ((NSError) -> Void)? = nil) {
        context.performAndWait {
            if context.hasChanges {
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
    
}
