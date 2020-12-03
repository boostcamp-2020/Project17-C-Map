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
    
    func update(coordinate: Coordinate, info: POIInfo) {
        self.lng = coordinate.x
        self.lat = coordinate.y
        self.info?.update(info: info)
    }
    
    func setValues(coordinate: Coordinate, info: POIInfoMO) {
        setValue(coordinate.id, forKey: Name.id)
        setValue(coordinate.x, forKey: Name.lng)
        setValue(coordinate.y, forKey: Name.lat)
        setValue(info, forKey: Name.info)
    }
    
}
