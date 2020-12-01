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
    
    private let createMarkerHandler: ([InteractiveMarker]) -> Void
    private let removeMarkerHandler: ([InteractiveMarker]) -> Void
    private var presentMarkers: [CLong: [InteractiveMarker]] = [:]
    
    init(createMarkerHandler: @escaping ([InteractiveMarker]) -> Void,
         removeMarkerHandler: @escaping ([InteractiveMarker]) -> Void) {
        self.createMarkerHandler = createMarkerHandler
        self.removeMarkerHandler = removeMarkerHandler
    }
    
    func clustersToMarkers(tileId: CLong, clusters: [Cluster]) {
        let markers = clusters.map {
            InteractiveMarker(cluster: $0)
        }
        presentMarkers[tileId] = markers
        createMarkerHandler(markers)
    }
    
    func removePresentMarkers(tileIds: [CLong]) {
        let markers = presentMarkers.filter { tileIds.contains($0.key) }.flatMap { $0.value }
        removeMarkerHandler(markers)
    }
    
}
