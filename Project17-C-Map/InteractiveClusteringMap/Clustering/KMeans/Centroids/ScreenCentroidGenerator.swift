//
//  ScreenCentroidGenerator.swift
//  InteractiveClusteringMap
//
//  Created by Seungeon Kim on 2020/11/28.
//

import Foundation

final class ScreenCentroidGenerator: CentroidGeneratable {
    
    private let topLeft: Coordinate
    private let bottomRight: Coordinate
    private let k: Int
    
    init(k: Int, topLeft: Coordinate, bottomRight: Coordinate) {
        self.k = k
        self.topLeft = topLeft
        self.bottomRight = bottomRight
    }
    
    func centroids() -> [Coordinate] {
        let center = (topLeft + bottomRight) / 2.0
        let boundary = Coordinate(x: bottomRight.x - center.x, y: topLeft.y - center.y)
        let pivot = center.findTheta(vertex: Coordinate(x: bottomRight.x, y: topLeft.y))
        
        let increase = Degree.turn / Double(k)
        var angle = increase
        var coords: [Coordinate] = []
        
        for _ in 0..<k {
            let quadrant = Quadrant.findQuadrant(angle: angle)
            let modulus = angle.truncatingRemainder(dividingBy: Degree.right)
            
            if modulus == 0 {
                let distance = boundary / 2
                let coord =  quadrant.degree(center: center, boundary: distance)
                coords.append(coord)
            } else {
                let theta = quadrant.theta(angle: modulus)
                let radian = theta * .pi / Degree.straight
                var x: Double
                var y: Double
                
                if theta > pivot {
                    y = boundary.y
                    x = y / tan(radian)
                } else {
                    x = boundary.x
                    y = tan(radian) * x
                }
                let distance = Coordinate(x: x, y: y) / 2
                let coord = quadrant.convertToCoordinate(center: center, distance: distance)
                coords.append(coord)
            }
            angle += increase
        }
        
        return coords
    }
    
}
