//
//  POIService.swift
//  InteractiveClusteringMap
//
//  Created by Oh Donggeon on 2020/11/23.
//

import Foundation

protocol POIServicing {
    
    func fetch(completion: @escaping ([POI]) -> Void)
    func save()
}

final class POIService: POIServicing {
    
    private let dataManager: DataManagable
    
    init(dataManager: DataManagable) {
        self.dataManager = dataManager
    }
    
    func fetch(completion: @escaping ([POI]) -> Void) {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            
            let poiEntities = self.dataManager.fetch()
            
            var pois: [POI] = []
            
            poiEntities.forEach {
                pois.append(POI(x: $0.x,
                                y: $0.y,
                                id: $0.id,
                                name: $0.name,
                                imageUrl: $0.imageUrl,
                                category: $0.category))
            }
            completion(pois)
        }
    }
    
    func save() {
        dataManager.save(successHandler: nil, failureHandler: nil)
    }
    
}
