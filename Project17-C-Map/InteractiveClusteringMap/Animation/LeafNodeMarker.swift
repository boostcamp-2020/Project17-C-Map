//
//  LeafNodeMarker.swift
//  InteractiveClusteringMap
//
//  Created by 박성민 on 2020/12/06.
//

import Foundation
import NMapsMap

final class LeafNodeMarker: NMFMarker, Markerable {
    
    private(set) var coordinate: Coordinate
    
    required init(coordinate: Coordinate) {
        self.coordinate = coordinate
        super.init()
        position = NMGLatLng(lat: coordinate.y, lng: coordinate.x)
        
        configure()
    }
    
    func configure() {
        iconImage = NMF_MARKER_IMAGE_GREEN
        
    }

    func remove() {
        mapView = nil
    }
    
}
