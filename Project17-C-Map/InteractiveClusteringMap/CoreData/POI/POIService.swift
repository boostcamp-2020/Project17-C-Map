//
//  POIService.swift
//  InteractiveClusteringMap
//
//  Created by Oh Donggeon on 2020/11/23.
//

import Foundation

protocol POIServicing {
    
    func fetch(completion: @escaping ([Coordinate]) -> Void)
    func save()
}

final class POIService: POIServicing {
    
    private let dataManager: DataManagable
    
    init(dataManager: DataManagable) {
        self.dataManager = dataManager
    }
    
    func fetch(completion: @escaping ([Coordinate]) -> Void) {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            
            let poiEntities = self.dataManager.fetch()
            var coords: [Coordinate] = []
            
            poiEntities.forEach {
                coords.append(Coordinate(x: $0.lng, y: $0.lat))
            }
            completion(coords)
        }
    }
    
    func save() {
        dataManager.save(successHandler: nil, failureHandler: nil)
    }
    
}
