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

// AverageSilhouetteMethod
class AverageSilhouetteCalculator {
    
    private let clusters: [Cluster]
    
    init(clusters: [Cluster]) {
        self.clusters = clusters
    }
    
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

    // 점과 현재 포함된 클러스터의 응집도 계산
    func findCohesion(in cluster: Cluster, target: Coordinate) -> Double {
        var totalDistance = 0.0
        let coordinates = cluster.coordinates.filter { $0 != target }
        coordinates.forEach {
            totalDistance += target.distanceTo($0)
        }
        return totalDistance / Double(coordinates.count)
    }

    // 점과 포함되지 않은 클러스터 간의 분리도 계산
    func findSeparation(in cluster: Cluster, target: Coordinate) -> Double {
        var totalDistances: [Double] = [Double]()
        let otherClusters = clusters.filter { $0.coordinates != cluster.coordinates }
        otherClusters.forEach {
            totalDistances.append(findCohesion(in: $0, target: target))
            print("================")
            print(totalDistances)
        }
        return totalDistances.min() ?? 0
    }
    
}
