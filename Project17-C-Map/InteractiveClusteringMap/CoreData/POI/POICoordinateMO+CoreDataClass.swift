//
//  POICoordinateMO+CoreDataClass.swift
//  
//
//  Created by Oh Donggeon on 2020/12/02.
//
//

import Foundation
import CoreData

@objc(POICoordinateMO)
public class POICoordinateMO: NSManagedObject {
    
    func setValues(_ coordinate: Coordinate) {
        setValue(coordinate.x, forKey: Name.lng)
        setValue(coordinate.y, forKey: Name.lat)
    }
    
}
