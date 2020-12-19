//
//  DataManagable.swift
//  InteractiveClusteringMap
//
//  Created by Oh Donggeon on 2020/11/21.
//

import Foundation
import CoreData

protocol DataManagable {
    
    func deleteAll()
    func delete(coordinate: Coordinate)
    func add(poi: POI)
    func update(poi: POI)
    
    func fetch(coordinate: Coordinate) -> [POIMO]
    func fetch(bottomLeft: Coordinate, topRight: Coordinate, handler: @escaping ([POIMO]) -> Void)
   
    func save(successHandler: (() -> Void)?, failureHandler: ((NSError) -> Void)?)
    
}
