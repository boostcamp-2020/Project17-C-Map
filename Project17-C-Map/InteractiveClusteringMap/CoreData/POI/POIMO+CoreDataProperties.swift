//
//  POIMO+CoreDataProperties.swift
//  
//
//  Created by Oh Donggeon on 2020/12/02.
//
//

import Foundation
import CoreData

extension POIMO {
    
    enum Name {
        static let id: String = "id"
        static let lat: String = "lat"
        static let lng: String = "lng"
        static let info: String = "info"
        
        static let rangeLngPredicateFormat: String = "%lf <= lng && lng <= %lf"
        static let rangeLatPredicateFormat: String = "%lf <= lat && lat <= %lf"
        static let equalIDPredicateFormat: String = "id == %d"
    }
    
    static let name: String = "POI"
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<POIMO> {
        return NSFetchRequest<POIMO>(entityName: "POI")
    }
    
    @nonobjc class func fetchRequest(coordinate: Coordinate) -> NSFetchRequest<POIMO> {
        let request: NSFetchRequest<POIMO> = fetchRequest()
        let predicate = NSPredicate(format: Name.equalIDPredicateFormat, coordinate.id)
        
        request.predicate = predicate
        
        return request
    }
    
    @nonobjc class func fetchRequest(bottomLeft: Coordinate, topRight: Coordinate) -> NSFetchRequest<POIMO> {
        let request: NSFetchRequest<POIMO> = fetchRequest()
        let lngPredicate = NSPredicate(format: Name.rangeLngPredicateFormat, bottomLeft.x, topRight.x)
        let latPredicate = NSPredicate(format: Name.rangeLatPredicateFormat, bottomLeft.y, topRight.y)
        
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [lngPredicate, latPredicate])
        
        return request
    }
    
    @NSManaged public var id: Int64
    @NSManaged public var lat: Double
    @NSManaged public var lng: Double
    @NSManaged public var info: POIInfoMO?
    
    var coordinate: Coordinate {
        return Coordinate(x: lng, y: lat, id: id)
    }
    
    var poi: POI? {
        guard let info = self.info else {
            return nil
        }
        return POI(x: lng, y: lat, id: id,
                   name: info.name, imageUrl: info.imageUrl, category: info.category)
    }
    
}
