//
//  KCoefficient.swift
//  InteractiveClusteringMap
//
//  Created by A on 2020/11/25.
//

import Foundation

// rule of thumb
func KwithRuleOfThumb(numberOfData: Int) -> Int {
    Int(sqrt(Double(numberOfData/2)))
}

// AverageSilhouetteMethod
class AverageSilhouetteCalculator {
    
    }
    
    private static func calculateAverageSilhouette(clusters:[Cluster], cluster: Cluster) -> Double {
        var silhouettes = [Double]()
        cluster.coordinates.forEach { coordinate in
            silhouettes.append(calculateSilhouette(clusters: clusters, with: cluster, target: coordinate))
        }
        return silhouettes.reduce(.zero, +) / Double(silhouettes.count)
    }

    private static func calculateSilhouette(clusters: [Cluster], with cluster: Cluster, target: Coordinate) -> Double {
        guard !cluster.coordinates.isEmpty else {
            return 0.0
        }
        let cohesion = calculateCohesion(in: cluster, target: target)
        let separation = calculateSeparation(clusters: clusters, in: cluster, target: target)
        return (separation - cohesion) / max(cohesion, separation)
    }

    // 점과 현재 포함된 클러스터의 응집도 계산
    private static func calculateCohesion(in cluster: Cluster, target: Coordinate) -> Double {
        var totalDistance = 0.0
        let coordinates = cluster.coordinates.filter { $0 != target }
        coordinates.forEach {
            totalDistance += target.distanceTo($0)
        }
        return totalDistance / Double(coordinates.count)
    }

    // 점과 포함되지 않은 클러스터 간의 분리도 계산
    private static func calculateSeparation(clusters: [Cluster], in cluster: Cluster, target: Coordinate) -> Double {
        var totalDistances: [Double] = [Double]()
        let otherClusters = clusters.filter { $0.coordinates != cluster.coordinates }
        otherClusters.forEach {
            totalDistances.append(calculateCohesion(in: $0, target: target))
        }
        return totalDistances.min() ?? 0
    }
    
}
