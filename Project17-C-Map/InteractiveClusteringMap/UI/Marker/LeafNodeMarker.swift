//
//  LeafNodeMarker.swift
//  InteractiveClusteringMap
//
//  Created by 박성민 on 2020/12/06.
//

import Foundation
import NMapsMap

final class LeafNodeMarker: NMFMarker, Markable {
    
    private enum InfoKey {
        static let title = "title"
        static let category = "category"
    }

    let coordinate: Coordinate
    private(set) var leafNodeMarkerLayer: LeafNodeMarkerLayer
    
    var markerLayer: CALayer {
        leafNodeMarkerLayer
    }
    
    var naverMapView: NMFMapView? {
        mapView
    }

    required init(coordinate: Coordinate) {
        self.coordinate = coordinate
        leafNodeMarkerLayer = LeafNodeMarkerLayer()
        super.init()
        
        createMarkerLayer()
        configure()
    }
    
    init(latlng: NMGLatLng) {
        coordinate = Coordinate(x: latlng.lng, y: latlng.lat)
        leafNodeMarkerLayer = LeafNodeMarkerLayer()
        super.init()
        
        createMarkerLayer()
        configure()
    }
    
    func createMarkerLayer() {
        leafNodeMarkerLayer = LeafNodeMarkerLayer()
        leafNodeMarkerLayer.bounds = CGRect(x: 0, y: 0,
                                    width: iconImage.imageWidth,
                                    height: iconImage.imageHeight)
        leafNodeMarkerLayer.contents = iconImage.image.cgImage
    }
    
    func configure() {
        position = NMGLatLng(lat: coordinate.y, lng: coordinate.x)
        iconImage = NMF_MARKER_IMAGE_GREEN
    }
    
    func configureUserInfo(userInfo: POIInfo?) {
        self.userInfo[InfoKey.title] = userInfo?.name ?? ""
        self.userInfo[InfoKey.category] = userInfo?.category ?? ""
    }
    
    func resizeMarkerSize() {
        width = iconImage.imageWidth
        height = iconImage.imageHeight
    }
    
    func sizeUp() {
        width = iconImage.imageWidth + 11
        height = iconImage.imageHeight + 11
    }
    
    func containsMarker(at point: CGPoint) -> Bool {
        guard let editButtonRange = mapView?.project(from: NMGLatLng(lat: coordinate.y, lng: coordinate.x))
        else {
            return false
        }
        
        let x = editButtonRange.x - iconImage.imageWidth / 2
        let y = editButtonRange.y - iconImage.imageHeight
        
        let containX = (x..<x + 30).contains(point.x)
        let containY = (y..<y + 30).contains(point.y)
        
        return containX && containY
    }
    
    func animate(position: CGPoint) {
        let animation = AnimationController.leafNodeAnimation(position: position)
        
        leafNodeMarkerLayer.anchorPoint = CGPoint(x: 0.5, y: 1)
        leafNodeMarkerLayer.position = position
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        CATransaction.setCompletionBlock { [weak self] in
            self?.leafNodeMarkerLayer.removeFromSuperlayer()
            self?.hidden = false
        }
        leafNodeMarkerLayer.add(animation, forKey: "markerAnimation")
        CATransaction.commit()
    }
    
}
