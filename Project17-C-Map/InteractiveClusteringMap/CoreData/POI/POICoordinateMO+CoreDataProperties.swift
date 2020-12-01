//
//  POICoordinateMO+CoreDataProperties.swift
//  
//
//  Created by Oh Donggeon on 2020/12/02.
//
//

import Foundation
import CoreData

extension POICoordinateMO {
    
    enum Name {
        static let lat: String = "lat"
        static let lng: String = "lng"
    }
    
    static let name: String = "POICoordinate"
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<POICoordinateMO> {
        return NSFetchRequest<POICoordinateMO>(entityName: name)
    }

    @NSManaged public var lat: Double
    @NSManaged public var lng: Double

}
