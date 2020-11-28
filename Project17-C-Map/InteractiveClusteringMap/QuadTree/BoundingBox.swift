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
    
    var ratio: Double {
        (topRight.x - bottomLeft.x) / (topRight.y - bottomLeft.y)
    }
    
    func splittedQuadBoundingBoxes() -> [BoundingBox] {
        let center = topRight.center(other: bottomLeft)
        return [
            BoundingBox(topRight: center, bottomLeft: bottomLeft),
            BoundingBox(topRight: Coordinate(x: topRight.x, y: center.y),
                        bottomLeft: Coordinate(x: center.x, y: bottomLeft.y)),
            BoundingBox(topRight: Coordinate(x: center.x, y: topRight.y),
                        bottomLeft: Coordinate(x: bottomLeft.x, y: center.y)),
            BoundingBox(topRight: topRight, bottomLeft: center)
        ]
    }
    
    func contains(coordinate: Coordinate) -> Bool {
        let containsX: Bool = (bottomLeft.x <= coordinate.x) && (coordinate.x <= topRight.x)
        let containsY: Bool = (bottomLeft.y <= coordinate.y) && (coordinate.y <= topRight.y)
        
        return (containsX && containsY)
    }
    
    func isOverlapped(with other: BoundingBox) -> Bool {
        self.bottomLeft <= other.topRight && other.bottomLeft <= self.topRight
    }
    
}

extension BoundingBox: Equatable {}
