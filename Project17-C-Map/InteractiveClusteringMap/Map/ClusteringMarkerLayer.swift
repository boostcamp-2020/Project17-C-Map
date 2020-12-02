//
//  ClusteringMarkerLayer.swift
//  InteractiveClusteringMap
//
//  Created by 박성민 on 2020/12/02.
//

import Foundation
import NMapsMap
import UIKit

protocol Markerable {
    
    init(cluster: Cluster)
    
}

class ClusteringMarkerLayer: CALayer, Markerable {
    
    var center: Coordinate?
    var coordinatesCount: Int?
    
    required init(cluster: Cluster) {
        super.init()
        commonInit(cluster: cluster)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func commonInit(cluster: Cluster) {
        self.center = cluster.center
        self.coordinatesCount = cluster.coordinates.count
        configure()
    }
    
    private func configure() {
        guard let coordinatesCount = coordinatesCount else { return }
        
        var r: CGFloat = 20
                
        r += CGFloat(coordinatesCount / 1000)
        
        bounds = CGRect(x: 0, y: 0, width: 2 * r, height: 2 * r)
        cornerRadius = r
    }
    
    func setScreenPosition(mapView: NMFMapView) {
        guard let center = center else { return }
        
        position = mapView.projection.point(from: NMGLatLng(lat: center.y, lng: center.x))
    }
    
}
