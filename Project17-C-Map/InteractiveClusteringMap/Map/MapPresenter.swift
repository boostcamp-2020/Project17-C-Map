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
    private var undeletedTileIds: [CLong] = []
    
    init(createMarkerHandler: @escaping ([Markerable]) -> Void,
         removeMarkerHandler: @escaping ([Markerable]) -> Void) {
        self.createMarkerHandler = createMarkerHandler
        self.removeMarkerHandler = removeMarkerHandler
    }
    
    func clustersToMarkers(tileId: CLong, clusters: [Cluster]) {
        guard !undeletedTileIds.contains(tileId) else {
            return undeletedTileIds.removeAll { $0 == tileId }
        }
        
        let markers: [Markerable] = clusters.map {
            if $0.coordinates.count == 1 {
                return InteractiveMarker(cluster: $0)
            } else {
                return InteractiveMarker(cluster: $0)
            }
        }
        presentMarkers[tileId] = (presentMarkers[tileId] ?? []) + markers
        createMarkerHandler(markers)
    }
    
    func removePresentMarkers(tileIds: [CLong]) {
        let targetIds = presentMarkers.filter { tileIds.contains($0.key) }
        undeletedTileIds += tileIds.filter { !targetIds.keys.contains($0) }
        
        let markers = targetIds.flatMap { $0.value }
        tileIds.forEach {
            presentMarkers[$0] = nil
        }
        removeMarkerHandler(markers)
    }
    
}
