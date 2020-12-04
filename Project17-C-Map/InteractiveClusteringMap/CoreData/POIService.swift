//
//  POIService.swift
//  InteractiveClusteringMap
//
//  Created by Oh Donggeon on 2020/11/23.
//

import Foundation

protocol POIServicing {
    
    func add(poi: POI)
    func update(poi: POI)
    func delete(coordinate: Coordinate)
    func fetch() -> [Coordinate]
    func fetch(completion: @escaping ([Coordinate]) -> Void)
    func fetch(coordinate: Coordinate) -> [POI]
    func fetch(coordiante: Coordinate, completion: @escaping ([POI]) -> Void)
    func fetch(bottomLeft: Coordinate, topRight: Coordinate) -> [Coordinate]
    func fetch(bottomLeft: Coordinate, topRight: Coordinate, completion: @escaping ([Coordinate]) -> Void)
    func save()
    
}

final class POIService: POIServicing {
    
    private let dataManager: DataManagable
    
    init(dataManager: DataManagable) {
        self.dataManager = dataManager
    }
    
    func add(poi: POI) {
        dataManager.add(poi: poi)
    }
    
    func update(poi: POI) {
        dataManager.update(poi: poi)
    }
    
    func delete(coordinate: Coordinate) {
        dataManager.delete(coordinate: coordinate)
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
    
    func fetch(coordinate: Coordinate) -> [POI] {
        let pois = dataManager.fetch(coordinate: coordinate)
        return pois.compactMap { $0.poi }
    }
    
    func fetch(coordiante: Coordinate, completion: @escaping ([POI]) -> Void) {
        dataManager.fetch(coordinate: coordiante) {
            completion($0.compactMap { $0.poi })
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
