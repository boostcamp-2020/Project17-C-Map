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
    func fetchInfo(coordinate: Coordinate) -> POIInfo?
    func fetchInfo(bottomLeft: Coordinate, topRight: Coordinate, completion: @escaping ([Place]) -> Void)
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
    
    func fetchInfo(bottomLeft: Coordinate, topRight: Coordinate, completion: @escaping ([Place]) -> Void) {
        dataManager.fetch(bottomLeft: bottomLeft, topRight: topRight) { [weak self] pois in
            guard let self = self else { return }
            completion(self.places(from: pois))
        }
    }
    
    private func places(from pois: [POIMO]) -> [Place] {
        pois.compactMap {
            guard let info = $0.info?.info else { return nil }
            return Place(coordinate: Coordinate(x: $0.lng, y: $0.lat, id: $0.id), info: info)
        }
    }
    
    func save() {
        dataManager.save(successHandler: nil, failureHandler: nil)
    }
    
}
