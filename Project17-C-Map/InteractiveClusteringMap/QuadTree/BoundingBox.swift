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

