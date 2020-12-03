//
//  POIService.swift
//  InteractiveClusteringMap
//
//  Created by Oh Donggeon on 2020/11/23.
//

import Foundation

protocol POIServicing {
    
    func fetch(completion: @escaping ([Coordinate]) -> Void)
    func fetchAsync(completion: @escaping ([Coordinate]) -> Void)
    func fetchAsync(topLeft: Coordinate, bottomRight: Coordinate, completion: @escaping ([Coordinate]) -> Void)
    func save()
    
}

final class POIService: POIServicing {
    
    private let dataManager: DataManagable
    
    init(dataManager: DataManagable) {
        self.dataManager = dataManager
    }
    
    func fetch(completion: @escaping ([Coordinate]) -> Void) {
        let poiEntities = self.dataManager.fetch()
        completion(poiEntities.map { $0.coordinate })
    }
    
    func fetchAsync(completion: @escaping ([Coordinate]) -> Void) {
        self.dataManager.fetchAsync {
            completion($0.map { $0.coordinate })
        }
    }
    
    func fetchAsync(topLeft: Coordinate, bottomRight: Coordinate, completion: @escaping ([Coordinate]) -> Void) {
        self.dataManager.fetchAsync(topLeft: topLeft, bottomRight: bottomRight) {
            completion($0.map { $0.coordinate })
        }
    }
    
    func save() {
        dataManager.save(successHandler: nil, failureHandler: nil)
    }
    
}
