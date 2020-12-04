//
//  POIService.swift
//  InteractiveClusteringMap
//
//  Created by Oh Donggeon on 2020/11/23.
//

import Foundation

protocol POIServicing {
    
    func fetch() -> [Coordinate]
    func fetch(completion: @escaping ([Coordinate]) -> Void)
    func fetch(bottomLeft: Coordinate, topRight: Coordinate) -> [Coordinate]
    func fetch(bottomLeft: Coordinate, topRight: Coordinate, completion: @escaping ([Coordinate]) -> Void)
    func save()
    
}

final class POIService: POIServicing {
    
    private let dataManager: DataManagable
    
    init(dataManager: DataManagable) {
        self.dataManager = dataManager
    }
    
    func fetch() -> [Coordinate] {
        let pois = dataManager.fetch()
        return pois.map { $0.coordinate }
    }
    
    func fetch(completion: @escaping ([Coordinate]) -> Void) {
        dataManager.fetch {
            completion($0.map { $0.coordinate })
        }
    }
    
    func fetch(bottomLeft: Coordinate, topRight: Coordinate) -> [Coordinate] {
        let pois = dataManager.fetch(bottomLeft: bottomLeft, topRight: topRight)
        return pois.map { $0.coordinate }
    }
    
    func fetch(bottomLeft: Coordinate, topRight: Coordinate, completion: @escaping ([Coordinate]) -> Void) {
        dataManager.fetch(bottomLeft: bottomLeft, topRight: topRight) {
            completion($0.map { $0.coordinate })
        }
    }
    
    func save() {
        dataManager.save(successHandler: nil, failureHandler: nil)
    }
    
}
