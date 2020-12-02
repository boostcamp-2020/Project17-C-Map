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
    
}

class ClusteringMarkerLayer: CALayer, Markerable {
    
    var center: Coordinate = Coordinate(x: 0, y: 0)
    var coordinatesCount: Int?
    
    required init(cluster: Cluster) {
        super.init()
        commonInit(cluster: cluster)
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
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
        
        r += CGFloat(2 * log2(Double(coordinatesCount)))
        
        bounds = CGRect(x: 0, y: 0, width: 2 * r, height: 2 * r)
        cornerRadius = r
        backgroundColor = UIColor(red: 0.1, green: 0.23, blue: 0.5, alpha: 0.8).cgColor
        DispatchQueue.main.async {
            self.textLayer(size: r)
        }
        
    }
    
    private func textLayer(size: CGFloat) {
        let textLayer = CATextLayer()
        textLayer.bounds = CGRect(x: 0, y: 0, width: size * 2, height: 20)
        textLayer.position = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        textLayer.fontSize = 15
        textLayer.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        textLayer.alignmentMode = .center
        textLayer.string = "\(coordinatesCount ?? 0)"
        textLayer.isWrapped = true
        textLayer.truncationMode = .end
        textLayer.backgroundColor = UIColor.clear.cgColor
        textLayer.foregroundColor = UIColor.white.cgColor
        
        textLayer.contentsScale = UIScreen.main.scale
        
        self.addSublayer(textLayer)
        textLayer.displayIfNeeded()
        
    }
    
    func setScreenPosition(position: CGPoint) {
        self.position = position
    }
    
}
