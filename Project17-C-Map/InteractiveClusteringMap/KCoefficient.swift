//
//  KCoefficient.swift
//  InteractiveClusteringMap
//
//  Created by A on 2020/11/25.
//

import Foundation

// rule of thumb
func KwithRuleOfThumb(numberOfData: Int) -> Int {
    return Int(sqrt(Double(numberOfData/2)))
}

class AverageSilhouetteCalculator {
    
    // AverageSilhouetteMethod
    func findAverageSilhouette(with clusters: [Cluster]) {
        clusters.forEach { cluster in
           
        }
        
    }

    func findSilhoutte(with cluster: Cluster, target: Coordinate) -> Double {
        guard !cluster.coordinates.isEmpty else {
            return 0.0
        }
        let cohesion = findCohesion(in: cluster, target: target)
        let separation = findSeparation(in: cluster, target: target)
        return (separation - cohesion) / max(cohesion, separation)
    }

    func findCohesion(in cluster: Cluster, target: Coordinate) -> Double {
        var totalDistance = 0.0
        cluster.coordinates.forEach {
            totalDistance += target.distanceTo($0)
        }
        return totalDistance / Double(cluster.coordinates.count)
    }

    func findSeparation(in cluster: Cluster, target: Coordinate) -> Double {
        var totalDistances: [Double] = []()
    }
}

