//
//  POIMO+CoreDataClass.swift
//  
//
//  Created by Oh Donggeon on 2020/12/02.
//
//

import Foundation
import CoreData

@objc(POIMO)
public class POIMO: NSManagedObject {
    
    func update(_ poi: POI) {
        self.lng = poi.x
        self.lat = poi.y
        self.info?.update(info: POIInfo(name: poi.name, imageUrl: poi.imageUrl, category: poi.category))
    }
    
    func setValues(coordinate: Coordinate, info: POIInfoMO) {
        setValue(coordinate.id, forKey: Name.id)
        setValue(coordinate.x, forKey: Name.lng)
        setValue(coordinate.y, forKey: Name.lat)
        setValue(info, forKey: Name.info)
    }
    
}
