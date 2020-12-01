//
//  DBI.swift
//  InteractiveClusteringMap
//
//  Created by A on 2020/12/01.
//

import Foundation

class DBI {
    
    let clusters: [Cluster]
    
    init(clusters: [Cluster]) {
        self.clusters = clusters
    }
    
    func sum() -> Double {
        var sum = 0.0
        clusters.forEach { cluster in
            let searchs = clusters.filter { $0 != cluster }
            var arr = [Double]()
            searchs.forEach { search in
                let distance = cluster.center.distanceTo(search.center)
                arr.append(sigma(cluster: cluster) + sigma(cluster: search) / distance)
            }
            sum += arr.max() ?? 0
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
    
    func calculateDBI() -> Double {
        let sum1 = sum()
        print("count: \(clusters.count)")
        if sum1 == 0 || clusters.count == 0 {
            return Double.infinity
        }
        return sum1 / Double(clusters.count)
    }
    
}
