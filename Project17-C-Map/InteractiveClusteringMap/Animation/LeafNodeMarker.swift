//
//  LeafNodeMarker.swift
//  InteractiveClusteringMap
//
//  Created by 박성민 on 2020/12/06.
//

import Foundation
import NMapsMap

final class LeafNodeMarker: NMFMarker, Markerable {
    
    let coordinate: Coordinate
    
    required init(coordinate: Coordinate) {
        self.coordinate = coordinate
        super.init()
        
        configure()
    }
    
    func configure() {
        position = NMGLatLng(lat: coordinate.y, lng: coordinate.x)
        iconImage = NMF_MARKER_IMAGE_GREEN
    }

    func remove() {
        mapView = nil
    }
    
}
