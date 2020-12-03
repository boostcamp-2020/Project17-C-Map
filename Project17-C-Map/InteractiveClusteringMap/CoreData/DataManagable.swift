//
//  DataManagable.swift
//  InteractiveClusteringMap
//
//  Created by Oh Donggeon on 2020/11/21.
//

import Foundation
import CoreData

protocol DataManagable {
    
    func fetch() -> [POICoordinateMO]
    func fetchAsync(handler: @escaping ([POICoordinateMO]) -> Void)
    func fetch(topLeft: Coordinate, bottomRight: Coordinate) -> [POICoordinateMO]
    func fetchAsync(topLeft: Coordinate, bottomRight: Coordinate, handler: @escaping ([POICoordinateMO]) -> Void)
    func save(successHandler: (() -> Void)?, failureHandler: ((NSError) -> Void)?)
    func setValue(_ poi: POI)
    
}
