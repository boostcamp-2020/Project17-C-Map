//
//  DBI.swift
//  InteractiveClusteringMap
//
//  Created by A on 2020/12/01.
//

import Foundation

struct DBI {
    
    func sum(clusters: [Cluster]) -> Double {
        var sum = 0.0
        clusters.forEach { cluster in
            var maximumSigma = Double.zero
            
            clusters.forEach { otherCluster in
                if cluster != otherCluster {
                    let distance = cluster.center.distanceTo(otherCluster.center)
                    let sigma = (self.sigma(cluster: cluster) + self.sigma(cluster: otherCluster)) / distance
                    maximumSigma = max(maximumSigma, sigma)
                }
                sum += maximumSigma
            }
        }
        return sum
    }
    
    func sigma(cluster: Cluster) -> Double {
        var sum = 0.0
        let center = cluster.center
        cluster.coordinates.forEach {
            sum += center.distanceTo($0)
        }
        return sum / Double(cluster.coordinates.count)
    }
    
    func calculateDBI(clusters: [Cluster]) -> Double {
        let sum = self.sum(clusters: clusters)
        if sum == 0 || clusters.count == 0 {
            return Double.infinity
        }
        return sum / Double(clusters.count)
    }
    
}
