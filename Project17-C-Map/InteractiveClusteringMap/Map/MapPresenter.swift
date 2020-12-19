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

protocol POIDataPresentationLogic {
    
    func add(tileId: CLong, poi: POI)
    func delete(coordinate: Coordinate)
    
}

final class MapPresenter: ClusterPresentationLogic {
    
    private let createMarkerHandler: ([NMFMarker]) -> Void
    private let removeMarkerHandler: ([NMFMarker]) -> Void
    private var presentMarkers: [CLong: [NMFMarker]] = [:]
    private var undeletedTileIds: [CLong] = []
    private let serialQueue = DispatchQueue(label: Name.serialQueue)
    var leafNodeMarkerTouchHandler: ((LeafNodeMarker) -> Bool)?
    var clusterNodeMarkerTouchHandler: ((ClusteringMarker) -> Bool)?
    
    init(createMarkerHandler: @escaping ([NMFMarker]) -> Void,
         removeMarkerHandler: @escaping ([NMFMarker]) -> Void) {
        self.createMarkerHandler = createMarkerHandler
        self.removeMarkerHandler = removeMarkerHandler
    }
    
    func clustersToMarkers(tileId: CLong, clusters: [Cluster]) {
        serialQueue.async { [weak self] in
            guard let self = self else { return }
            
            guard !self.undeletedTileIds.contains(tileId)
            else {
                return self.undeletedTileIds.removeAll { $0 == tileId }
            }
            
            let markers: [NMFMarker] = clusters.map {
                if $0.coordinates.count == 1 {
                    return self.leafNodeMarker(cluster: $0)
                }
                return self.clusterMarker(cluster: $0)
            }
            self.presentMarkers[tileId] = (self.presentMarkers[tileId] ?? []) + markers
            
            DispatchQueue.main.async {
                self.createMarkerHandler(markers)
            }
        }
    }
    
    func removePresentMarkers(tileIds: [CLong]) {
        serialQueue.async { [weak self] in
            guard let self = self else { return }
            
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
    
    private func leafNodeMarker(cluster: Cluster) -> LeafNodeMarker {
        let marker = LeafNodeMarker(coordinate: cluster.coordinates.first ?? Coordinate(x: 0, y: 0))
        
        marker.touchHandler = { [weak self] (_) -> Bool in
            guard let handler = self?.leafNodeMarkerTouchHandler else { return false }
            return handler(marker)
        }
        return marker
    }
    
    private func clusterMarker(cluster: Cluster) -> ClusteringMarker {
        let marker = ClusteringMarker(cluster: cluster)
        
        marker.touchHandler = { [weak self] (_) -> Bool in
            guard let handler = self?.clusterNodeMarkerTouchHandler else { return false }
            return handler(marker)
        }
        return marker
    }

}

extension MapPresenter: POIDataPresentationLogic {
    
    func add(tileId: CLong, poi: POI) {
        let leafMarker = LeafNodeMarker(coordinate: Coordinate(x: poi.x, y: poi.y, id: poi.id))
        presentMarkers[tileId]?.append(leafMarker)
        createMarkerHandler([leafMarker])
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

private extension MapPresenter {
    
    enum Name {
        static let serialQueue: String = "MapPresenter.SerialQueue"
    }
}
