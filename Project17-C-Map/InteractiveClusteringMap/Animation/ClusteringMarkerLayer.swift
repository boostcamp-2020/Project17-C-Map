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
    
    var coordinate: Coordinate { get }
    func remove()
    
}

class ClusteringMarkerLayer: CALayer, Markerable {
    
    private(set) var coordinate: Coordinate
    private let coordinatesCount: Int
    var textLayer: MarkerTextLayer
    
    required init(cluster: Cluster) {
        
        self.coordinate = cluster.center
        self.coordinatesCount = cluster.coordinates.count
        self.textLayer = MarkerTextLayer(radius: 0, text: "")
        super.init()
        
        configure()
    }
    
    override init(layer: Any) {
        self.coordinate = Coordinate(x: 0, y: 0)
        self.coordinatesCount = 0
        self.textLayer = MarkerTextLayer(radius: 0, text: "")
        super.init(layer: layer)
    }
    
    required init?(coder: NSCoder) {
        self.coordinate = Coordinate(x: 0, y: 0)
        self.coordinatesCount = 0
        self.textLayer = MarkerTextLayer(radius: 0, text: "")
        super.init(coder: coder)
    }
    
    private func configure() {
        let r: CGFloat = 18 + CGFloat(2 * log2(Double(coordinatesCount)))
        
        bounds = CGRect(x: 0, y: 0, width: 2 * r, height: 2 * r)
        cornerRadius = r
        backgroundColor = UIColor(red: 0.1, green: 0.23, blue: 0.5, alpha: 0.8).cgColor
        textLayer = MarkerTextLayer(radius: r, text: "\(self.coordinatesCount)")
        textLayer.position = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        self.addSublayer(textLayer)
        }
    
    func updatePosition(position: CGPoint) {
        self.position = position
    }
    
    func remove() {
        removeFromSuperlayer()
    }
}
