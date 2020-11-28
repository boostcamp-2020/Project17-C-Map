//
//  MapInteractor.swift
//  InteractiveClusteringMap
//
//  Created by eunjeong lee on 2020/11/29.
//

import Foundation

protocol ClusterCompleteDelegate: class {
    
    func didComplete(clusters: [Cluster])
    
}

protocol Interactable: class {
    
    func fetch(boundingBox: BoundingBox, zoomLevel: Double)
    
}

class MapInteractor: Interactable {
    
    private let poiService: POIServicing
//    private let clusteringServicing: ClusteringServicing
    private var clusteringServicing: QuadTreeClusteringService?
    weak var delegate: ClusterCompleteDelegate?

    init(poiService: POIServicing
//         clusteringServicing: ClusteringServicing
    ) {
        self.poiService = poiService
//        self.clusteringServicing = clusteringServicing
    }
    
    func fetch(boundingBox: BoundingBox, zoomLevel: Double) {
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
    
    private func clustering(coordinates: [Coordinate],
                            boundingBox: BoundingBox,
                            zoomLevel: Double) {
        clusteringServicing = QuadTreeClusteringService(coordinates: coordinates, boundingBox: boundingBox)
        clusteringServicing?.execute(coordinates: coordinates,
                                    boundingBox: boundingBox,
                                    zoomLevel: zoomLevel) { [weak self] clusters in
            guard let self = self else { return }
            
            self.delegate?.didComplete(clusters: clusters)
        }
    }
    
}
