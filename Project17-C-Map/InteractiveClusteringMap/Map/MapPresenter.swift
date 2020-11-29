//
//  MapPresenter.swift
//  InteractiveClusteringMap
//
//  Created by eunjeong lee on 2020/11/29.
//

import Foundation

protocol ClusterPresentationLogic {
    
    func clustersToMarkers(clusters: [Cluster])
    
}

class MapPresnter: ClusterPresentationLogic {
    
    private let markerHandler: ([InteractiveMarker]) -> Void
    
    init(markerHandler: @escaping ([InteractiveMarker]) -> Void) {
        self.markerHandler = markerHandler
    }
    
    func clustersToMarkers(clusters: [Cluster]) {
        let markers = clusters.map {
            InteractiveMarker(cluster: $0)
        }
        markerHandler(markers)
    }

}
