//
//  POIInfoMO+CoreDataProperties.swift
//  
//
//  Created by Oh Donggeon on 2020/12/02.
//
//

import Foundation
import CoreData


extension POIInfoMO {
    
    enum Name {
        static let category: String = "category"
        static let imageUrl: String = "imageUrl"
        static let name: String = "name"
    }
    
    static let name: String = "POIInfo"
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<POIInfoMO> {
        return NSFetchRequest<POIInfoMO>(entityName: name)
    }

    @NSManaged public var category: String?
    @NSManaged public var imageUrl: String?
    @NSManaged public var name: String?
    
}
