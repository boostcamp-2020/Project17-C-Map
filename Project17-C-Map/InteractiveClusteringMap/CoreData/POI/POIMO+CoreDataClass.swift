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
    
    func setValues(id: Int64, coordinate: POICoordinateMO, info: POIInfoMO) {
        setValue(id, forKey: Name.id)
        setValue(coordinate, forKey: Name.coordinate)
        setValue(info, forKey: Name.info)
    }
    
}
