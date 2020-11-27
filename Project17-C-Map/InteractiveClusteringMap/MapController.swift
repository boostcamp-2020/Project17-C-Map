//
//  MapController.swift
//  InteractiveClusteringMap
//
//  Created by 박성민 on 2020/11/21.
//

import Foundation
import NMapsMap

final class MapController {
    
    private weak var interactiveMapView: InteractiveMapView?
    private let poiServicing: POIServicing
    
    init(mapView: InteractiveMapView, poiServicing: POIServicing) {
        self.interactiveMapView = mapView
        self.poiServicing = poiServicing
    }
    
    func loadMarkers() {
        poiServicing.fetch { [weak self] pois in
            self?.createMarkers(pois: pois)
        }
    }
    
    private func createMarkers(pois: [POI]) {
        pois.forEach { POI in
            DispatchQueue.global(qos: .userInteractive).async {
                let location = NMGLatLng(lat: POI.y, lng: POI.x)
                let marker = NMFMarker()
                marker.position = location
                marker.iconTintColor = .green
                DispatchQueue.main.async { [weak self] in
                    marker.mapView = self?.interactiveMapView?.mapView
                }
            }
        }
    }
    
}
