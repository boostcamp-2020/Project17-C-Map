//
//  MapInteractor.swift
//  InteractiveClusteringMap
//
//  Created by eunjeong lee on 2020/11/29.
//

import Foundation

protocol ClusterBusinessLogic: class {
    
    func fetch(boundingBoxes: [CLong: BoundingBox], zoomLevel: Double)
    func remove(tileIds: [CLong])
    
}

protocol DataBusinessLogic: class {
    
    func add(tileId: CLong, poi: POI)
    func remove(coordinate: Coordinate)
    func fetch(coordinate: Coordinate) -> POIInfo?
    
}

final class MapInteractor: MapBusinessLogic {
    
    private let presenter: ClusterPresentationLogic
    private let quadTreeClusteringService: ClusteringServicing
    private let treeDataStore: TreeDataStorable
    
    init(treeDataStore: TreeDataStorable, presenter: ClusterPresentationLogic) {
        self.presenter = presenter
        self.treeDataStore = treeDataStore
        self.quadTreeClusteringService = QuadTreeClusteringService(treeDataStore: treeDataStore)
    }
    
    func fetch(boundingBoxes: [CLong: BoundingBox], zoomLevel: Double) {
        boundingBoxes.forEach { tileId, boundingBox in
            self.clustering(
                tileId: tileId,
                boundingBox: boundingBox,
                zoomLevel: zoomLevel)
        }
    }
    
    func fetch(coordinate: Coordinate) -> POIInfo? {
        return treeDataStore.fetch(coordinate: coordinate)
    }
    
    func remove(tileIds: [CLong]) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.presenter.removePresentMarkers(tileIds: tileIds)
        }
    }
    
    private func clustering(tileId: CLong,
                            boundingBox: BoundingBox,
                            zoomLevel: Double) {
        
        quadTreeClusteringService.execute(coordinates: nil,
                                          boundingBox: boundingBox,
                                          zoomLevel: zoomLevel) { [weak self] clusters in
            guard let self = self else { return }
            
            self.presenter.clustersToMarkers(tileId: tileId, clusters: clusters)
        }
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
