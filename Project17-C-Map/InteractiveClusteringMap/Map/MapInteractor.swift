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

final class MapInteractor: ClusterBusinessLogic {
    
    private let poiService: POIServicing
    private let presenter: ClusterPresentationLogic
    private var clusteringService: ClusteringServicing?
    
    init(poiService: POIServicing, presenter: ClusterPresentationLogic) {
        self.poiService = poiService
        self.presenter = presenter
    }
    
    func fetch(boundingBoxes: [CLong: BoundingBox], zoomLevel: Double) {
        boundingBoxes.forEach { tileId, boundingBox in
            self.poiService.fetch { [weak self] pois in
                guard let self = self else { return }
                
                let coordinates = pois.map {
                    Coordinate(x: $0.x, y: $0.y)
                }
                if self.clusteringService == nil {
                    self.clusteringService = QuadTreeClusteringService(coordinates: coordinates,
                                                                         boundingBox: BoundingBox.korea)
                }
                self.clustering(coordinates: coordinates,
                                tileId: tileId,
                                boundingBox: boundingBox,
                                zoomLevel: zoomLevel)
            }
        }
    }
    
    func remove(tileIds: [CLong]) {
        presenter.removePresentMarkers(tileIds: tileIds)
    }
    
    private func clustering(coordinates: [Coordinate],
                            tileId: CLong,
                            boundingBox: BoundingBox,
                            zoomLevel: Double) {
        
        clusteringService?.execute(coordinates: coordinates,
                                     boundingBox: boundingBox,
                                     zoomLevel: zoomLevel) { [weak self] clusters in
            guard let self = self else { return }
                                      
            self.presenter.clustersToMarkers(tileId: tileId, clusters: clusters)
        }
    }
    
}
