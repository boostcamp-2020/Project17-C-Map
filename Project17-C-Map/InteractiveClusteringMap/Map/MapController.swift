//
//  MapController.swift
//  InteractiveClusteringMap
//
//  Created by 박성민 on 2020/11/21.
//

import Foundation
import NMapsMap

final class MapController {
    
    private var clusters = [Cluster]() {
        didSet {
            createMarkers(clusters: clusters)
        }
    }
    
    private weak var interactiveMapView: InteractiveMapView?
    
    init(mapView: InteractiveMapView) {
        self.interactiveMapView = mapView
    }
    
    func update(clusters: [Cluster]) {
        self.clusters = clusters
    }
    
    private func createMarkers(clusters: [Cluster]) {
        clusters.forEach { cluster in
            let location = NMGLatLng(lat: cluster.center.y, lng: cluster.center.x)
            let marker = NMFMarker()
            marker.position = location
            marker.iconTintColor = .green
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                marker.mapView = self.interactiveMapView?.mapView
            }
        }
    }
    
}
