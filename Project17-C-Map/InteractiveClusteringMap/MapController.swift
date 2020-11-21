//
//  MapController.swift
//  InteractiveClusteringMap
//
//  Created by 박성민 on 2020/11/21.
//

import Foundation
import NMapsMap

//mockup POI
struct POI {
    let x: Double
    let y: Double
}

final class MapController {
    
    private weak var interactiveMapView: InteractiveMapView?
    private let POIs: [POI]
    
    init(mapView: InteractiveMapView, POIs: [POI]) {
        self.interactiveMapView = mapView
        self.POIs = POIs
    }
    
    func createMarkers() {
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            self?.POIs.forEach { POI in
                let location = NMGLatLng(lat: POI.x, lng: POI.y)
                let marker = NMFMarker()
                marker.position = location
                marker.iconTintColor = .green
                DispatchQueue.main.async {
                    marker.mapView = self?.interactiveMapView?.mapView
                }
            }
        }
    }
    
}
