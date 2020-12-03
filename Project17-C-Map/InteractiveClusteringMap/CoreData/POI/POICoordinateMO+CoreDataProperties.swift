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
    
    @nonobjc class func fetchRequest(bottomLeft: Coordinate, topRight: Coordinate) -> NSFetchRequest<POICoordinateMO> {
        let request: NSFetchRequest<POICoordinateMO> = fetchRequest()
        let lngPredicate = NSPredicate(format: "%lf <= lng && lng <= %lf", bottomLeft.x, topRight.x)
        let latPredicate = NSPredicate(format: "%lf <= lat && lat <= %lf", bottomLeft.y, topRight.y)
        
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [lngPredicate, latPredicate])
        
        return request
    }
    
    @NSManaged public var lat: Double
    @NSManaged public var lng: Double
    
    var coordinate: Coordinate {
        return Coordinate(x: self.lng, y: self.lat)
    }

}
