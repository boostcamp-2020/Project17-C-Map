//
//  ClusteringMarkerLayer.swift
//  InteractiveClusteringMap
//
//  Created by 박성민 on 2020/12/02.
//

import Foundation
import UIKit
import Darwin

protocol Markerable {
    
    init(cluster: Cluster)
    func remove()
    
}

class ClusteringMarkerLayer: CALayer, Markerable {
    
    let center: Coordinate
    private let coordinatesCount: Int
    
    required init(cluster: Cluster) {
        
        self.center = cluster.center
        self.coordinatesCount = cluster.coordinates.count
        super.init()

        configure()
    }
    
    override init(layer: Any) {
        self.center = Coordinate(x: 0, y: 0)
        self.coordinatesCount = 0
        super.init(layer: layer)
    }
    
    required init?(coder: NSCoder) {
        self.center = Coordinate(x: 0, y: 0)
        self.coordinatesCount = 0
        super.init(coder: coder)
    }
    
    private func configure() {
        let r: CGFloat = 15 + CGFloat(2 * log2(Double(coordinatesCount)))
        
        bounds = CGRect(x: 0, y: 0, width: 2 * r, height: 2 * r)
        cornerRadius = r
        backgroundColor = UIColor(red: 0.1, green: 0.23, blue: 0.5, alpha: 0.8).cgColor
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            let textLayer = MarkerTextLayer(size: r, text: "\(self.coordinatesCount)")
            textLayer.position = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
            self.addSublayer(textLayer)
        }
        
    }
    
    
    func updatePosition(position: CGPoint) {
        self.position = position
    }
        
    func remove() {
        removeFromSuperlayer()
    }
}
