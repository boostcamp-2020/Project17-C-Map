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
        
        backgroundColor = ClusteringColor.getColor(count: coordinatesCount).cgColor
        
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
    case fifty = 50
    case hundred = 100
    case thousand = 1000
    case fiveThousand = 5000
    case tenThousand = 10000
}

extension ClusteringColor {
    
    static func getColor(count: Int) -> UIColor {
        switch count {
        case 1..<ClusteringColor.fifty.rawValue:
            return UIColor(red: 53/255, green: 60/255, blue: 130/255, alpha: 0.9)
        case ClusteringColor.fifty.rawValue..<ClusteringColor.hundred.rawValue:
            return UIColor(red: 250/255, green: 200/255, blue: 33/255, alpha: 0.9)
        case ClusteringColor.hundred.rawValue..<ClusteringColor.thousand.rawValue:
            return UIColor(red: 252/255, green: 145/255, blue: 58/255, alpha: 0.9)
        case ClusteringColor.thousand.rawValue..<ClusteringColor.fiveThousand.rawValue:
            return UIColor(red: 255/255, green: 78/255, blue: 80/255, alpha: 0.9)
        default:
            return UIColor(red: 92/255, green: 25/255, blue: 107/255, alpha: 0.9)
        }
    }
    
}
