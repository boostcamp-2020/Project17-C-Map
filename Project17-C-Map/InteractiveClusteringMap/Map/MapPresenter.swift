//
//  MapPresenter.swift
//  InteractiveClusteringMap
//
//  Created by eunjeong lee on 2020/11/29.
//

import Foundation
import NMapsMap

protocol ClusterPresentationLogic {
    
    func clustersToMarkers(tileId: CLong, clusters: [Cluster])
    func removePresentMarkers(tileIds: [CLong])
    
}

class MapPresenter: ClusterPresentationLogic {
    
    private let createMarkerHandler: ([NMFMarker]) -> Void
    private let removeMarkerHandler: ([NMFMarker]) -> Void
    private var presentMarkers: [CLong: [NMFMarker]] = [:]
    private var undeletedTileIds: [CLong] = []
    private let serialQueue = DispatchQueue(label: Name.serialQueue)
    
    init(createMarkerHandler: @escaping ([NMFMarker]) -> Void,
         removeMarkerHandler: @escaping ([NMFMarker]) -> Void) {
        self.createMarkerHandler = createMarkerHandler
        self.removeMarkerHandler = removeMarkerHandler
    }
    
    func clustersToMarkers(tileId: CLong, clusters: [Cluster]) {
        serialQueue.async {
            guard !self.undeletedTileIds.contains(tileId) else {
                return self.undeletedTileIds.removeAll { $0 == tileId }
            }
            
            let markers: [NMFMarker] = clusters.map {
                if $0.coordinates.count == 1 {
                    return LeafNodeMarker(coordinate: $0.coordinates.first ?? Coordinate(x: 0, y: 0))
                } else {
                    return InteractiveMarker(cluster: $0)
                }
            }
            self.presentMarkers[tileId] = (self.presentMarkers[tileId] ?? []) + markers
            
            DispatchQueue.main.async {
                self.createMarkerHandler(markers)
            }
        }
        
    }
    
    func removePresentMarkers(tileIds: [CLong]) {
        serialQueue.async {
            let targetIds = self.presentMarkers.filter { tileIds.contains($0.key) }
            self.undeletedTileIds += tileIds.filter { !targetIds.keys.contains($0) }
            
            let markers = targetIds.flatMap { $0.value }
            tileIds.forEach {
                self.presentMarkers[$0] = nil
            }
            
            DispatchQueue.main.async {
                self.removeMarkerHandler(markers)
            }
        }
        
    }
    
}

private extension MapPresenter {
    
    enum Name {
        static let serialQueue: String = "MapPresenter.SerialQueue"
    }
}
