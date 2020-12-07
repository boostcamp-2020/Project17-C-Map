//
//  ClusteringMarkerLayer.swift
//  InteractiveClusteringMap
//
//  Created by 박성민 on 2020/12/02.
//

import Foundation
import UIKit
import Darwin

class ClusteringMarkerLayer: CALayer {
    
    let coordinate: Coordinate
    private let coordinatesCount: Int
    private var textLayer: MarkerTextLayer
    
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
        
        if coordinatesCount <= ClusteringColor.hundred.rawValue {
            backgroundColor = ClusteringColor.hundred.value.cgColor
        } else if coordinatesCount <= ClusteringColor.thousand.rawValue {
            backgroundColor = ClusteringColor.thousand.value.cgColor
        } else if coordinatesCount <= ClusteringColor.tenThousand.rawValue {
            backgroundColor = ClusteringColor.tenThousand.value.cgColor
        } else {
            backgroundColor = ClusteringColor.hundredThousand.value.cgColor
        }
        
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

enum ClusteringColor: Int {
    case hundred = 100
    case thousand = 1000
    case tenThousand = 10000
    case hundredThousand = 100000
}

extension ClusteringColor {
    var value: UIColor {
        
        switch self {
        case .hundred:
            return UIColor(red: 0.1, green: 0.23, blue: 0.5, alpha: 0.8)
        case .thousand:
            return UIColor(red: 253/255, green: 225/255, blue: 169/255, alpha: 0.8)
        case .tenThousand:
            return UIColor(red: 248/255, green: 157/255, blue: 112/255, alpha: 0.8)
        case .hundredThousand:
            return UIColor(red: 213/255, green: 84/255, blue: 75/255, alpha: 0.8)
            
        }
    }
}
