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
    
    private let queue: DispatchQueue = .init(label: "CoreDataStackQueue", qos: .background, attributes: .concurrent)
    
    private let fileName: String = "restuarant-list-for-test"
    
    private init() {
        let pois = JSONReader.readPOIs(fileName: fileName)
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
            guard let self = self else { return }
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = POICoordinateMO.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "lng >= %@ AND lng <= %@ AND lat >= %@ AND lat <= %@",
                                                 topLeft.x, bottomRight.x, bottomRight.y, topLeft.y)
            guard let context = self.context,
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
        
        let poiMO = NSEntityDescription.insertNewObject(forEntityName: POIMO.name, into: context)
        let coordMO = NSEntityDescription.insertNewObject(forEntityName: POICoordinateMO.name, into: context)
        let infoMO = NSEntityDescription.insertNewObject(forEntityName: POIInfoMO.name, into: context)
        
        poiMO.setValue(poi.id, forKey: POIMO.Name.id)
        poiMO.setValue(coordMO, forKey: POIMO.Name.coordinate)
        poiMO.setValue(infoMO, forKey: POIMO.Name.info)
        coordMO.setValue(poi.x, forKey: POICoordinateMO.Name.lng)
        coordMO.setValue(poi.y, forKey: POICoordinateMO.Name.lat)
        infoMO.setValue(poi.name, forKey: POIInfoMO.Name.name)
        infoMO.setValue(poi.imageUrl, forKey: POIInfoMO.Name.imageUrl)
        infoMO.setValue(poi.category, forKey: POIInfoMO.Name.category)
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
