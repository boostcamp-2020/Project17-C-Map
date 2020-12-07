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
    func delete(coordinate: Coordinate)
    
}

class MapPresenter: ClusterPresentationLogic {
    
    private let createMarkerHandler: ([NMFMarker]) -> Void
    private let removeMarkerHandler: ([NMFMarker]) -> Void
    private var presentMarkers: [CLong: [NMFMarker]] = [:]
    private var undeletedTileIds: [CLong] = []
    
    init(createMarkerHandler: @escaping ([NMFMarker]) -> Void,
         removeMarkerHandler: @escaping ([NMFMarker]) -> Void) {
        self.createMarkerHandler = createMarkerHandler
        self.removeMarkerHandler = removeMarkerHandler
    }
    
    func clustersToMarkers(tileId: CLong, clusters: [Cluster]) {
        guard !undeletedTileIds.contains(tileId) else {
            return undeletedTileIds.removeAll { $0 == tileId }
        }
        
        let markers: [NMFMarker] = clusters.map {
            if $0.coordinates.count == 1 {
                return LeafNodeMarker(coordinate: $0.coordinates.first ?? Coordinate(x: 0, y: 0))
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
    
    func delete(coordinate: Coordinate) {
        let targetID = coordinate.id
        
        for (markersKey, markersValue) in presentMarkers {
            presentMarkers[markersKey] = markersValue.filter { marker in
                guard let leafMarker = marker as? LeafNodeMarker else {
                    return true
                }
                let leafMarkerID = leafMarker.coordinate.id
                
                guard targetID != leafMarkerID else {
                    leafMarker.mapView = nil
                    return false
                }
                return true
            }
        }
    }
    
}
