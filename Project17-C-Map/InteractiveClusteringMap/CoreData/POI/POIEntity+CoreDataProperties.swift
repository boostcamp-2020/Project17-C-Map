//
//  POIEntity+CoreDataProperties.swift
//  
//
//  Created by Oh Donggeon on 2020/11/21.
//
//

import Foundation
import CoreData


extension POIEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<POIEntity> {
        return NSFetchRequest<POIEntity>(entityName: "POIEntity")
    }

    @NSManaged public var category: String?
    @NSManaged public var id: Int64
    @NSManaged public var imageUrl: String?
    @NSManaged public var name: String?
    @NSManaged public var x: Double
    @NSManaged public var y: Double
    
    static let name: String = "POIEntity"

}
