//
//  POIService.swift
//  InteractiveClusteringMap
//
//  Created by Oh Donggeon on 2020/11/23.
//

import Foundation

protocol POIServicing {
    
    func add(coordinate: Coordinate)
    func update(poi: POI)
    func delete(coordinate: Coordinate)
    func fetch(bottomLeft: Coordinate, topRight: Coordinate, completion: @escaping ([Coordinate]) -> Void)
    func fetch(coordinate: Coordinate) -> POIInfo
    func save()
    
}

final class POIService: POIServicing {
    
    private let dataManager: DataManagable
    private var coordinates: [Coordinate] = []
    
    init(dataManager: DataManagable) {
        self.dataManager = dataManager
    }
    
    func add(coordinate: Coordinate) {
        dataManager.add(coordinate: coordinate)
    }
    
    func update(poi: POI) {
        dataManager.update(poi: poi)
    }
    
    func delete(coordinate: Coordinate) {
        dataManager.delete(coordinate: coordinate)
    }
    
    func fetch(bottomLeft: Coordinate, topRight: Coordinate, completion: @escaping ([Coordinate]) -> Void) {
        dataManager.fetch(bottomLeft: bottomLeft, topRight: topRight) {
            completion($0.map { $0.coordinate })
        }
    }
    
    func fetch(coordinate: Coordinate) -> POIInfo {
        return dataManager.fetch(coordinate: coordinate).compactMap {
            $0.info?.info
        }.first ?? POIInfo(name: "", imageUrl: "", category: "")
    }
    
    func save() {
        dataManager.save(successHandler: nil, failureHandler: nil)
    }
    
}
