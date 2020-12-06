//
//  LeafNodeMarkerLayer.swift
//  InteractiveClusteringMap
//
//  Created by A on 2020/12/06.
//

import Foundation
import UIKit

class LeafNodeMarkerLayer: CALayer {
    
    private let marker: LeafNodeMarker
    
    init(marker: LeafNodeMarker) {
        self.marker = marker
        super.init()
        configure()
    }
    
    required init?(coder: NSCoder) {
        self.marker = LeafNodeMarker(coordinate: Coordinate(x: 0, y: 0))
        super.init()
        configure()
    }
    
    private func configure() {
        bounds = CGRect(x: 0, y: 0, width: marker.iconImage.imageWidth, height: marker.iconImage.imageHeight)
        contents = marker.iconImage.image.cgImage
        contentsGravity = CALayerContentsGravity.resize
        anchorPoint = CGPoint(x: 0.5, y: 1)
        
//        position = self.interactiveMapView.projectPoint(from: NMGLatLng(lat: leafNodeMarker.coordinate.y, lng: leafNodeMarker.coordinate.x))
    }
    
}
