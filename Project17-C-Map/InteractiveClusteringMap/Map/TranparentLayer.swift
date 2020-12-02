//
//  TranparentLayer.swift
//  InteractiveClusteringMap
//
//  Created by 박성민 on 2020/12/02.
//

import Foundation
import UIKit

class TransparentLayer: CALayer {
    
    init(bounds: CGRect) {
        super.init()
        configure(bounds: bounds)
    }
    
    required init?(coder: NSCoder) {
        super.init()
    }
    
    func configure(bounds: CGRect) {
        self.bounds = bounds
        self.backgroundColor = UIColor.clear.cgColor
        self.position = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        let clusterMarker = ClusteringMarkerLayer(cluster: Cluster(coordinates: [Coordinate(x: 126.9956437, y: 37.5764792)]))
        clusterMarker.backgroundColor = UIColor.blue.cgColor
        clusterMarker.position = CGPoint(x: 100, y: 100)
        addSublayer(clusterMarker)
    }
    
}
