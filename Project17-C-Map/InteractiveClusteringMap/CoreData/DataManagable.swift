//
//  DataManagable.swift
//  InteractiveClusteringMap
//
//  Created by Oh Donggeon on 2020/11/21.
//

import Foundation

protocol DataManagable {
    
    func fetch() -> [POIEntity]
    func save(successHandler: (() -> Void)?, failureHandler: ((NSError) -> Void)?)
    func setValue(_ poi: POI)
    
}
