//
//  DataInteractor.swift
//  InteractiveClusteringMap
//
//  Created by eunjeong lee on 2020/12/20.
//

import Foundation

protocol POIDataBusinessLogic: class {
    
    func add(tileId: CLong, poi: POI)
    func remove(coordinate: Coordinate)
    func fetch(coordinate: Coordinate) -> POIInfo?
    
}

final class POIDataInteractor: POIDataBusinessLogic {
    
    private let presenter: POIDataPresentationLogic
    private let treeDataStore: TreeDataStorable
    
    init(treeDataStore: TreeDataStorable, presenter: POIDataPresentationLogic) {
        self.treeDataStore = treeDataStore
        self.presenter = presenter
    }
    
    func fetch(coordinate: Coordinate) -> POIInfo? {
        return treeDataStore.fetch(coordinate: coordinate)
    }
    
    func add(tileId: CLong, poi: POI) {
        treeDataStore.add(poi: poi)
        presenter.add(tileId: tileId, poi: poi)
    }
    
    func remove(coordinate: Coordinate) {
        treeDataStore.remove(coordinate: coordinate)
        presenter.delete(coordinate: coordinate)
    }
    
}
