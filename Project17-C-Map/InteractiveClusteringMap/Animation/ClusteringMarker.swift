//
//  ClusteringMarker.swift
//  InteractiveClusteringMap
//
//  Created by eunjeong lee on 2020/11/29.
//

import Foundation
import NMapsMap

final class ClusteringMarker: NMFMarker {
    
    let coordinate: Coordinate
    let coordinatesCount: Int
    private(set) var markerLayer: ClusteringMarkerLayer
    let boundingBox: BoundingBox
    let cluster: Cluster

    required init(cluster: Cluster) {
        self.cluster = cluster
        self.coordinate = cluster.center
        self.coordinatesCount = cluster.coordinates.count
        self.markerLayer = ClusteringMarkerLayer(cluster: cluster)
        self.boundingBox = cluster.boundingBox
        super.init()
        position = NMGLatLng(lat: cluster.center.y, lng: cluster.center.x)
        
        let uiImage = imageFromLayer(layer: markerLayer)
        configure(image: uiImage)
    }
    
    func configure(image: UIImage) {
        iconImage = NMFOverlayImage(image: image)
        
        iconTintColor = ClusteringColor.getColor(count: coordinatesCount)
        
        anchor = CGPoint(x: 0.5, y: 0.5)
        alpha = 0.9
    }
    
    func imageFromLayer(layer: CALayer) -> UIImage {
        let originalColor = layer.backgroundColor
        
        defer {
            layer.backgroundColor = originalColor
        }
        
        layer.backgroundColor = UIColor.black.cgColor
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, layer.isOpaque, 0)
        
        guard let uiGraphicsGetCurrentContext = UIGraphicsGetCurrentContext() else {
            return UIImage()
        }
        
        layer.render(in: uiGraphicsGetCurrentContext)
        
        guard let outputImage = UIGraphicsGetImageFromCurrentImageContext() else {
            return UIImage()
        }
        UIGraphicsEndImageContext()
        
        return outputImage
    }
    
    func createBoundingBoxPolygon() -> NMFPolygonOverlay? {
        let topRight = NMGLatLng(lat: boundingBox.topRight.y, lng: boundingBox.topRight.x)
        let bottomLeft = NMGLatLng(lat: boundingBox.bottomLeft.y, lng: boundingBox.bottomLeft.x)
    
        let coords = [bottomLeft,
                       NMGLatLng(lat: bottomLeft.lat, lng: topRight.lng),
                       topRight,
                       NMGLatLng(lat: topRight.lat, lng: bottomLeft.lng),
                       bottomLeft]
        
        let polygon = NMGPolygon(ring: NMGLineString(points: coords)) as NMGPolygon<AnyObject>
        let polygonOverlay = NMFPolygonOverlay(polygon)
        
        polygonOverlay?.fillColor = UIColor(named: "polygon") ?? UIColor.red
        polygonOverlay?.outlineWidth = 1
        
        return polygonOverlay
    }
    
    override func animate(position: CGPoint) {
        let animation = AnimationController.transformScale(option: .increase)
        markerLayer.position = position
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        CATransaction.setCompletionBlock { [weak self] in
            self?.markerLayer.removeFromSuperlayer()
            self?.hidden = false
        }
        markerLayer.add(animation, forKey: "markerAnimation")
        CATransaction.commit()
        
    }
    
}

extension ClusteringMarker: NMFOverlayImageDataSource {
    
    func view(with overlay: NMFOverlay) -> UIView {
        guard let marker = overlay as? NMFMarker else { return UIView() }
        
        let markerView = UIImageView(frame: CGRect(x: 0,
                                                   y: 0,
                                                   width: marker.iconImage.imageWidth,
                                                   height: marker.iconImage.imageHeight))
        return markerView
    }
}
