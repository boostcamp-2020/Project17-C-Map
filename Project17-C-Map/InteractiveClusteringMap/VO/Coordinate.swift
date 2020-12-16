//
//  Coordinate.swift
//  InteractiveClusteringMap
//
//  Created by Seungeon Kim on 2020/11/27.
//

import Foundation

struct Coordinate {
    
    let x: Double
    let y: Double
    let id: String
    
    init(x: Double, y: Double, id: String = UUID().uuidString) {
        self.x = x
        self.y = y
        self.id = id
    }
    
    func ratio(other: Coordinate) -> Double {
        return (self.x - other.x) / (self.y - other.y)
    }
    
    func distanceTo(_ other: Coordinate) -> Double {
        let powX = pow(self.x - other.x, 2.0)
        let powY = pow(self.y - other.y, 2.0)
        
        return sqrt(powX + powY)
    }
    
    func center(other: Coordinate) -> Coordinate {
        let centerX: Double = (self.x + other.x) / 2.0
        let centerY: Double = (self.y + other.y) / 2.0
        
        return Coordinate(x: centerX, y: centerY)
    }
    
    func findTheta(vertex: Coordinate) -> Double {
        let gradient = (vertex.y - self.y) / (vertex.x - self.x)
        
        return atan(gradient) * 180 / .pi
    }
    
}

extension Coordinate {
    
    static func randomGenerate(rangeOfLat lats: ClosedRange<Double>,
                               rangeOfLng lngs: ClosedRange<Double>) -> Coordinate {
        let lat = Double.random(in: lats)
        let lng = Double.random(in: lngs)
        
        return Coordinate(x: lng, y: lat)
    }
    
}

extension Coordinate: Hashable {
    
    static let zero = Coordinate(x: 0, y: 0)
    
    static func + (left: Coordinate, right: Coordinate) -> Coordinate {
        let x = left.x + right.x
        let y = left.y + right.y
        
        return Coordinate(x: x, y: y)
    }
    
    static func - (left: Coordinate, right: Coordinate) -> Coordinate {
        let x = left.x - right.x
        let y = left.y - right.y
        
        return Coordinate(x: x, y: y)
    }
    
    static func / (left: Coordinate, right: Double) -> Coordinate {
        let x = left.x / right
        let y = left.y / right
        
        return Coordinate(x: x, y: y)
    }
    
    static func <= (left: Coordinate, right: Coordinate) -> Bool {
        left.x <= right.x && left.y <= right.y
    }
    
}
