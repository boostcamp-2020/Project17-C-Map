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
    func fetch(bottomLeft: Coordinate, topRight: Coordinate, completion: @escaping ([Coordinate]) -> Void)
    func fetchInfo(coordinate: Coordinate) -> Place?
    func fetchInfo(coordinate: Coordinate, completion: @escaping (Place?) -> Void)
    func fetchInfo(coordinate: Coordinate) -> POIInfo?
    func fetchInfo(coordinates: [Coordinate]) -> [POIInfo]
    func fetchInfo(coordinates: [Coordinate], completion: @escaping ([Place]) -> Void)
    func save()
    
}

final class POIService: POIServicing {
    
    private let dataManager: DataManagable
    private var coordinates: [Coordinate] = []
    
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
    
    func fetch(bottomLeft: Coordinate, topRight: Coordinate, completion: @escaping ([Coordinate]) -> Void) {
        dataManager.fetch(bottomLeft: bottomLeft, topRight: topRight) {
            completion($0.map { $0.coordinate })
        }
    }
    
    func fetchInfo(coordinate: Coordinate) -> POIInfo? {
        return dataManager.fetch(coordinate: coordinate).compactMap {
            $0.info?.info
        }.first
    }
    
    func fetchInfo(coordinates: [Coordinate]) -> [POIInfo] {
        let infoMO = dataManager.fetchInfo(coordinates: coordinates)
        return infoMO.map { $0.info }
    }
    
    func fetchInfo(coordinates: [Coordinate], completion: @escaping ([Place]) -> Void) {
        dataManager.fetchInfo(coordinates: coordinates) { info in
            if info.isEmpty { return completion([]) }
            let places = zip(coordinates, info).map { coordinate, info -> Place in
                return Place(coordinate: coordinate, info: info.info)
            }
            completion(places)
        }
    }
    
    func fetchInfo(coordinate: Coordinate) -> Place? {
        guard let infoMO = dataManager.fetchInfo(coordinate: coordinate) else {
            return nil
        }
        return Place(coordinate: coordinate, info: infoMO.info)
    }
    
    func fetchInfo(coordinate: Coordinate, completion: @escaping (Place?) -> Void) {
        fetchInfo(coordinates: [coordinate]) {
            completion($0.first)
        }
    }
    
    func save() {
        dataManager.save(successHandler: nil, failureHandler: nil)
    }
    
}
