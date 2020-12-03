//
//  DataManagable.swift
//  InteractiveClusteringMap
//
//  Created by Oh Donggeon on 2020/11/21.
//

import Foundation
import CoreData

protocol DataManagable {
    
    func fetch(handler: @escaping ([POICoordinateMO]) -> Void)
    func fetch(bottomLeft: Coordinate, topRight: Coordinate, handler: @escaping ([POICoordinateMO]) -> Void)
    func save(successHandler: (() -> Void)?, failureHandler: ((NSError) -> Void)?)
    func setValue(_ poi: POI)
    
}
