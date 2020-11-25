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
    
    func splittedQuadBoundingBoxes() -> [BoundingBox] {
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

extension BoundingBox: Equatable {}

struct Coordinate: Equatable {
    
    let x: Double
    let y: Double
    
    static func <= (left: Coordinate, right: Coordinate) -> Bool {
        left.x <= right.x && left.y <= right.y
    }
    
    func center(other: Coordinate) -> Coordinate {
        let centerX: Double = (self.x + other.x) / 2.0
        let centerY: Double = (self.y + other.y) / 2.0
        return Coordinate(x: centerX, y: centerY)
    }
    
}

struct Cluster {
    let center: Coordinate
    let coordinates: [Coordinate]
}
