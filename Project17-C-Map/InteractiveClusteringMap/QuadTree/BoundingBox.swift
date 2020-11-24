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
    
    var splitedQuadBoundingBox: [BoundingBox] {
        [
            BoundingBox(topRight: Coordinate(x: mid.x, y: topRight.y),
                        bottomLeft: Coordinate(x: bottomLeft.x, y: mid.y)),
            BoundingBox(topRight: topRight, bottomLeft: mid),
            BoundingBox(topRight: mid, bottomLeft: bottomLeft),
            BoundingBox(topRight: Coordinate(x: topRight.x, y: mid.y),
                        bottomLeft: Coordinate(x: mid.x, y: bottomLeft.y))
        ]
    }
    
    private var mid: Coordinate {
        let midX: Double = (bottomLeft.x + topRight.x) / 2.0
        let midY: Double = (bottomLeft.y + topRight.y) / 2.0
        return Coordinate(x: midX, y: midY)
    }
    
    func contains(coordinate: Coordinate) -> Bool {
        let containsX: Bool = (bottomLeft.x <= coordinate.x) && (coordinate.x <= topRight.x)
        let containsY: Bool = (bottomLeft.y <= coordinate.y) && (coordinate.y <= topRight.y)
        return (containsX && containsY)
    }
    
    func intersectsBoxBounds(with box: BoundingBox) -> Bool {
        return (bottomLeft <= box.topRight &&  box.bottomLeft <= topRight)
    }
    
}

struct Coordinate: Equatable {
    
    let x: Double
    let y: Double
    
    static func <= (left: Coordinate, right: Coordinate) -> Bool {
        left.x <= right.x && left.y <= right.y
    }
    
}

struct Cluster {
    let center: Coordinate
    let coordinates: [Coordinate]
}
