//
//  Quadrant.swift
//  InteractiveClusteringMap
//
//  Created by Seungeon Kim on 2020/11/27.
//

import Foundation

enum Quadrant: Int {
    case first = 0, second = 1, third = 2, fourth = 3
    
    static func findQuadrant(angle: Double) -> Quadrant {
        guard angle != .zero else { return Quadrant.first }
        
        let number = Int(angle / Degree.right)
        if angle.truncatingRemainder(dividingBy: Degree.right) == 0 {
            return Quadrant(rawValue: number - 1) ?? Quadrant.first
        } else {
            return Quadrant(rawValue: number) ?? Quadrant.first
        }
    }
    
    func theta(angle: Double) -> Double {
        if self == .first || self == .third {
            return Degree.right - angle
        } else {
            return angle
        }
    }
    
    func degree(center: Coordinate, boundary: Coordinate) -> Coordinate {
        switch self {
        case .first:
            return Coordinate(x: center.x + boundary.x, y: center.y)
        case .second:
            return Coordinate(x: center.x, y: center.y - boundary.y)
        case .third:
            return Coordinate(x: center.x - boundary.x, y: center.y)
        case .fourth:
            return Coordinate(x: center.x, y: center.y + boundary.y)
        }
    }
    
    func convertToCoordinate(center: Coordinate, distance: Coordinate) -> Coordinate {
        switch self {
        case .first:
            return Coordinate(x: center.x + distance.x, y: center.y + distance.y)
        case .second:
            return Coordinate(x: center.x + distance.x, y: center.y - distance.y)
        case .third:
            return Coordinate(x: center.x - distance.x, y: center.y - distance.y)
        case .fourth:
            return Coordinate(x: center.x - distance.x, y: center.y + distance.y)
        }
    }
}
