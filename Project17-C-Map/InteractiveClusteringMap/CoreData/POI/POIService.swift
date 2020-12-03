//
//  POIService.swift
//  InteractiveClusteringMap
//
//  Created by Oh Donggeon on 2020/11/23.
//

import Foundation

protocol POIServicing {
    
    func fetch(completion: @escaping ([Coordinate]) -> Void)
    func fetch(bottomLeft: Coordinate, topRight: Coordinate, completion: @escaping ([Coordinate]) -> Void)
    func save()
    
}

final class POIService: POIServicing {
    
    private let dataManager: DataManagable
    
    init(dataManager: DataManagable) {
        self.dataManager = dataManager
    }
    
    func fetch(completion: @escaping ([Coordinate]) -> Void) {
        self.dataManager.fetch {
            completion($0.map { $0.coordinate })
        }
    }
    
    func fetch(bottomLeft: Coordinate, topRight: Coordinate, completion: @escaping ([Coordinate]) -> Void) {
        self.dataManager.fetch(bottomLeft: bottomLeft, topRight: topRight) {
            completion($0.map { $0.coordinate })
        }
    }
    
    func save() {
        dataManager.save(successHandler: nil, failureHandler: nil)
    }
    
}
