//
//  MapPresenter.swift
//  InteractiveClusteringMap
//
//  Created by eunjeong lee on 2020/11/29.
//

import Foundation

protocol ClusterPresentationLogic {
    
    func clustersToMarkers(tileId: CLong, clusters: [Cluster])
    func removePresentMarkers(tileIds: [CLong])
    
}

class MapPresenter: ClusterPresentationLogic {
    
    private let createMarkerHandler: ([Markerable]) -> Void
    private let removeMarkerHandler: ([Markerable]) -> Void
    private var presentMarkers: [CLong: [Markerable]] = [:]
    
    init(createMarkerHandler: @escaping ([Markerable]) -> Void,
         removeMarkerHandler: @escaping ([Markerable]) -> Void) {
        self.createMarkerHandler = createMarkerHandler
        self.removeMarkerHandler = removeMarkerHandler
    }
    
    func clustersToMarkers(tileId: CLong, clusters: [Cluster]) {
        let markers: [Markerable] = clusters.map {
            if $0.coordinates.count == 0 {
                return InteractiveMarker(cluster: $0)
            } else {
                return ClusteringMarkerLayer(cluster: $0)
            }
        }
        presentMarkers[tileId] = markers
        createMarkerHandler(markers)
    }
    
    func removePresentMarkers(tileIds: [CLong]) {
        let markers = presentMarkers.filter { tileIds.contains($0.key) }.flatMap { $0.value }
        removeMarkerHandler(markers)
    }
    
}
