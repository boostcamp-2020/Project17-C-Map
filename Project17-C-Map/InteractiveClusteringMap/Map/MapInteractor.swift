//
//  MapInteractor.swift
//  InteractiveClusteringMap
//
//  Created by eunjeong lee on 2020/11/29.
//

import Foundation

protocol ClusterBusinessLogic: class {
    
    func fetch(boundingBoxes: [BoundingBox], zoomLevel: Double)
    
}

final class MapInteractor: ClusterBusinessLogic {
    
    private let poiService: POIServicing
    private let presenter: ClusterPresentationLogic
//    private let clusteringServicing: ClusteringServicing
    private var clusteringServicing: QuadTreeClusteringService?

    init(poiService: POIServicing,
         presenter: ClusterPresentationLogic
//         clusteringServicing: ClusteringServicing
    ) {
        self.poiService = poiService
        self.presenter = presenter
//        self.clusteringServicing = clusteringServicing
    }
    
    func fetch(boundingBoxes: [BoundingBox], zoomLevel: Double) {
        boundingBoxes.forEach { boundingBox in
            poiService.fetch { [weak self] pois in
                guard let self = self else { return }
                
                let coordinates = pois.map {
                    Coordinate(x: $0.x, y: $0.y)
                }
                self.clustering(coordinates: coordinates,
                                boundingBox: boundingBox,
                                zoomLevel: zoomLevel)
            }
        }
    }
    
    private func clustering(coordinates: [Coordinate],
                            boundingBox: BoundingBox,
                            zoomLevel: Double) {
        if clusteringServicing == nil {
            clusteringServicing = QuadTreeClusteringService(coordinates: coordinates,
                                                            boundingBox: BoundingBox(topRight: Coordinate(x: 126.9956437, y: 37.5764792),
                                                                                     bottomLeft: Coordinate(x: 126.9903617, y: 37.5600365)))
        }
        clusteringServicing?.execute(coordinates: coordinates,
                                    boundingBox: boundingBox,
                                    zoomLevel: zoomLevel) { [weak self] clusters in
            guard let self = self else { return }
            self.presenter.clustersToMarkers(clusters: clusters)
        }
    }
    
}
