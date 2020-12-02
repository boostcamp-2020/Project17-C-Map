//
//  DBI.swift
//  InteractiveClusteringMap
//
//  Created by A on 2020/12/01.
//

import Foundation

struct DBI {
    
    private func sum(clusters: [Cluster]) -> Double {
        var sum = Double.zero
        
        clusters.forEach { cluster in
            var maximumSigma = Double.zero
            
            clusters.forEach { otherCluster in
                guard cluster != otherCluster else { return }
                
                let distance = cluster.center.distanceTo(otherCluster.center)
                let sigma = (self.sigma(cluster: cluster) + self.sigma(cluster: otherCluster)) / distance
                
                maximumSigma = max(maximumSigma, sigma)
                sum += maximumSigma
                
            }
        }
        return sum
    }
    
    private func sigma(cluster: Cluster) -> Double {
        let center = cluster.center
        let sum = cluster.coordinates.reduce(0.0) { $0 + center.distanceTo($1)}
        
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
