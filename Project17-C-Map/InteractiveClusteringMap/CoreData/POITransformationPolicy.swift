//
//  POITransformation.swift
//  InteractiveClusteringMap
//
//  Created by A on 2020/12/12.
//

import Foundation
import CoreData

class POITransformationPolicy: NSEntityMigrationPolicy {
    
    override func createDestinationInstances(forSource sInstance: NSManagedObject, in mapping: NSEntityMapping, manager: NSMigrationManager) throws {
        try super.createDestinationInstances(forSource: sInstance, in: mapping, manager: manager)
        
        print("Converting Event")
        
        guard let dInstance = manager.destinationInstances(forEntityMappingName: mapping.name, sourceInstances: [sInstance]).first else {
                    return
                }
        
        let POI = NSEntityDescription.insertNewObject(forEntityName: "POI", into: dInstance.managedObjectContext!)
        
        let id = sInstance.value(forKey: "id") as? Int64 ?? 0
        let stringId = String(id)
        
        POI.setValue(stringId, forKey: "id")
        POI.setValue(sInstance.value(forKey: "lat"), forKey: "lat")
        POI.setValue(sInstance.value(forKey: "lng"), forKey: "lng")
       
        print(stringId)
 
        manager.associate(sourceInstance: sInstance, withDestinationInstance: POI, for: mapping)
    }
    
}
