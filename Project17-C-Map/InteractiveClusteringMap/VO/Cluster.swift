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
