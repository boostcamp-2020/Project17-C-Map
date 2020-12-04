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
    
    func update(name: String?, category: String?, imageUrl: String?) {
        self.name = name
        self.category = category
        self.imageUrl = imageUrl
    }
    
    func update(info: POIInfo) {
        name = info.name
        category = info.category
        imageUrl = info.imageUrl
    }
    
    func setValues(_ info: POIInfo) {
        setValue(info.name, forKey: Name.name)
        setValue(info.category, forKey: Name.category)
        setValue(info.imageUrl, forKey: Name.imageUrl)
    }
    
}
