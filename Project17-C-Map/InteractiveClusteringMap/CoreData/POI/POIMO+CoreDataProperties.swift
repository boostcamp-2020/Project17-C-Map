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
        static let coordinate: String = "coordinate"
        static let info: String = "info"
    }

    static let name: String = "POI"
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<POIMO> {
        return NSFetchRequest<POIMO>(entityName: name)
    }
    
    @NSManaged public var id: Int64
    @NSManaged public var coordinate: POICoordinateMO?
    @NSManaged public var info: POIInfoMO?
    
}
