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
    
    func resizeMarkerSize() {
        width = iconImage.imageWidth
        height = iconImage.imageHeight
    }
    
    func sizeUp() {
        width = iconImage.imageWidth + 11
        height = iconImage.imageHeight + 11
    }
    
    override func animate(position: CGPoint) {
        let animation = AnimationController.leafNodeAnimation(position: position)
        guard let markerLayer = markerLayer else { return }
        
        markerLayer.anchorPoint = CGPoint(x: 0.5, y: 1)
        markerLayer.position = position
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        CATransaction.setCompletionBlock { [weak self] in
            markerLayer.removeFromSuperlayer()
            self?.hidden = false
        }
        markerLayer.add(animation, forKey: "markerAnimation")
        CATransaction.commit()
    }
    
}
