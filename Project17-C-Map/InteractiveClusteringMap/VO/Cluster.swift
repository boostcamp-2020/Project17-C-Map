//
//  Cluster.swift
//  InteractiveClusteringMap
//
//  Created by Seungeon Kim on 2020/11/27.
//

import Foundation

struct Cluster {
    var coordinates: [Coordinate]
    var center: Coordinate {
        coordinates.reduce(.zero, +) / Double(coordinates.count)
    }
    var boundingBox: BoundingBox
    
    init(coordinates: [Coordinate], boundingBox: BoundingBox) {
        self.coordinates = coordinates
        self.boundingBox = boundingBox
        
        if coordinates.count < 10000 {
            updateBoundingBox(coordinates: coordinates)
        }
    }
    
    mutating func updateBoundingBox(coordinates: [Coordinate]) {
        var maxX = boundingBox.bottomLeft.x
        var minX = boundingBox.topRight.x
        var maxY = boundingBox.bottomLeft.y
        var minY = boundingBox.topRight.y
        
        coordinates.forEach { coordinate in
            maxX = max(coordinate.x, maxX)
            minX = min(coordinate.x, minX)
            maxY = max(coordinate.y, maxY)
            minY = min(coordinate.y, minY)
        }
        let topRight = Coordinate(x: maxX, y: maxY)
        let bottomLeft = Coordinate(x: minX, y: minY)
        boundingBox = BoundingBox(topRight: topRight, bottomLeft: bottomLeft)
    }
    
}

extension Cluster: Hashable {
    
    static func == (lhs: Cluster, rhs: Cluster) -> Bool {
        return lhs.center == rhs.center &&
            lhs.coordinates == rhs.coordinates
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(coordinates)
    }
    
}
