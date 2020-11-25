//
//  BoundingBox.swift
//  InteractiveClusteringMap
//
//  Created by 박성민 on 2020/11/24.
//

import Foundation

struct BoundingBox {
    
    let topRight: Coordinate
    let bottomLeft: Coordinate
    
    func splitedQuadBoundingBox() -> [BoundingBox] {
        let center = topRight.center(other: bottomLeft)
        return [
            BoundingBox(topRight: Coordinate(x: center.x, y: topRight.y),
                        bottomLeft: Coordinate(x: bottomLeft.x, y: center.y)),
            BoundingBox(topRight: topRight, bottomLeft: center),
            BoundingBox(topRight: center, bottomLeft: bottomLeft),
            BoundingBox(topRight: Coordinate(x: topRight.x, y: center.y),
                        bottomLeft: Coordinate(x: center.x, y: bottomLeft.y))
        ]
    }
    
    func contains(coordinate: Coordinate) -> Bool {
        let containsX: Bool = (bottomLeft.x <= coordinate.x) && (coordinate.x <= topRight.x)
        let containsY: Bool = (bottomLeft.y <= coordinate.y) && (coordinate.y <= topRight.y)
        return (containsX && containsY)
    }
    
    func isOverlapped(with other: BoundingBox) -> Bool {
        return (self.bottomLeft <= other.topRight && other.bottomLeft <= self.topRight)
    }
    
}

struct Coordinate {
    
    let x: Double
    let y: Double
    
    func center(other: Coordinate) -> Coordinate {
        let centerX: Double = (self.x + other.x) / 2.0
        let centerY: Double = (self.y + other.y) / 2.0
        return Coordinate(x: centerX, y: centerY)
    }
    
    func distanceTo(_ other: Coordinate) -> Double {
        let powX = pow(self.x - other.x, 2.0)
        let powY = pow(self.y - other.y, 2.0)
        
        return sqrt(powX + powY)
    }
    
}

extension Coordinate: Hashable {
    
    static let zero = Coordinate(x: 0, y: 0)
    
    static func <= (left: Coordinate, right: Coordinate) -> Bool {
        left.x <= right.x && left.y <= right.y
    }
    
    static func + (lhs: Coordinate, rhs: Coordinate) -> Coordinate {
        return Coordinate(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    
    static func / (lhs: Coordinate, rhs: Double) -> Coordinate {
        return Coordinate(x: lhs.x / rhs, y: lhs.y / rhs)
    }
    
}

struct Cluster {
    
    var center: Coordinate
    var coordinates: [Coordinate]
    
    var updateCenter: Coordinate {
        coordinates.reduce(.zero, +) / Double(coordinates.count)
    }
    
    init(center: Coordinate, coordinates: [Coordinate]) {
        self.center = center
        self.coordinates = coordinates
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
