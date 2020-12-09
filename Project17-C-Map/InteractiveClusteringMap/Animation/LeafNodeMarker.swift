//
//  LeafNodeMarker.swift
//  InteractiveClusteringMap
//
//  Created by 박성민 on 2020/12/06.
//

import Foundation
import NMapsMap

final class LeafNodeMarker: NMFMarker {
    
    let coordinate: Coordinate
    private(set) var markerLayer: LeafNodeMarkerLayer?
    
    required init(coordinate: Coordinate) {
        self.coordinate = coordinate
        super.init()
        
        configure()
    }
    
    init(latlng: NMGLatLng) {
        coordinate = Coordinate(x: latlng.lng, y: latlng.lat)
        super.init()
        
        configure()
    }
    
    func createMarkerLayer() {
        markerLayer = LeafNodeMarkerLayer()
        guard let markerLayer = self.markerLayer else { return }
        
        markerLayer.bounds = CGRect(x: 0, y: 0,
                                    width: iconImage.imageWidth,
                                    height: iconImage.imageHeight)
        markerLayer.contents = iconImage.image.cgImage
    }
    
    func configure() {
        position = NMGLatLng(lat: coordinate.y, lng: coordinate.x)
        iconImage = NMF_MARKER_IMAGE_GREEN
    }
    
}
