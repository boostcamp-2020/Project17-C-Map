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
    private var clusteringServicing: ClusteringServicing?
    private var coordinates: [Coordinate] = []
    init(poiService: POIServicing, presenter: ClusterPresentationLogic) {
        self.poiService = poiService
        self.presenter = presenter
    }
    
    func fetch(boundingBoxes: [CLong: BoundingBox], zoomLevel: Double) {
        if coordinates.isEmpty {
            self.poiService.fetch { [weak self] pois in
                guard let self = self else { return }

                let coordinates = pois.map {
                    Coordinate(x: $0.x, y: $0.y)
                }
                
                let generator = BallCutCentroidGenerator(coverage: 0.001, coordinates: coordinates)
                self.clusteringServicing = KMeansValidateService(generator: generator)

                self.clustering(coordinates: coordinates,
                                tileId: boundingBoxes.first!.key,
                                boundingBox: boundingBoxes.first!.value,
                                zoomLevel: zoomLevel)
    //                DispatchQueue.global(qos: .userInitiated).async {
    //
    //                }
            }
        } else {
//            let generator = BallCutCentroidGenerator(coverage: 0.001, coordinates: coordinates)
//            self.clusteringServicing = KMeansValidateService(generator: generator)

            self.clustering(coordinates: coordinates,
                            tileId: boundingBoxes.first!.key,
                            boundingBox: boundingBoxes.first!.value,
                            zoomLevel: zoomLevel)
        }
        
    }
    
    func remove(tileIds: [CLong]) {
        presenter.removePresentMarkers(tileIds: tileIds)
    }
    
    private func clustering(coordinates: [Coordinate],
                            tileId: CLong,
                            boundingBox: BoundingBox,
                            zoomLevel: Double) {
        
        clusteringServicing?.execute(coordinates: coordinates,
                                     boundingBox: boundingBox,
                                     zoomLevel: zoomLevel) { [weak self] clusters in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.presenter.clustersToMarkers(tileId: tileId, clusters: clusters)
            }
        }
    }
    
}
