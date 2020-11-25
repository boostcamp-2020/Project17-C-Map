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
    
    let clusters: [Cluster]
    
    init(clusters: [Cluster]) {
        self.clusters = clusters
    }
    
    // AverageSilhouetteMethod
    func findAverageSilhouette(cluster: Cluster) -> Double {
        var silhouettes  = [Double]()
        cluster.coordinates.forEach { coordinate in
            silhouettes.append(findSilhouette(with: cluster, target: coordinate))
        }
        return silhouettes.reduce(.zero, +) / Double(silhouettes.count)
    }

    func findSilhouette(with cluster: Cluster, target: Coordinate) -> Double {
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
        var totalDistances: [Double] = [Double]()
        let otherClusters = clusters.filter { $0 != cluster }
        otherClusters.forEach {
            totalDistances.append(findCohesion(in: $0, target: target))
        }
        return totalDistances.min() ?? 0
    }
    
}
