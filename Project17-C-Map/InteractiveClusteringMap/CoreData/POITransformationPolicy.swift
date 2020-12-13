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

        let POI = NSEntityDescription.insertNewObject(forEntityName: "POI", into: manager.destinationContext)
        
        let id = sInstance.value(forKey: "id") as? Int64 ?? 0
        let stringId = String(id)
        
        POI.setValue(stringId, forKey: "id")
        POI.setValue(sInstance.value(forKey: "lat"), forKey: "lat")
        POI.setValue(sInstance.value(forKey: "lng"), forKey: "lng")
 
        manager.associate(sourceInstance: sInstance, withDestinationInstance: POI, for: mapping)
    }
    
}
