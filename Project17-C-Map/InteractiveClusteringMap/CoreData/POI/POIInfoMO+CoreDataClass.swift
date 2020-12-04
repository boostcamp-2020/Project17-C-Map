//
//  POIInfoMO+CoreDataClass.swift
//  
//
//  Created by Oh Donggeon on 2020/12/02.
//
//

import Foundation
import CoreData

@objc(POIInfoMO)
public class POIInfoMO: NSManagedObject {
    
    func setValues(_ info: POIInfo) {
        setValue(info.name, forKey: Name.name)
        setValue(info.category, forKey: Name.category)
        setValue(info.imageUrl, forKey: Name.imageUrl)
    }
    
}
