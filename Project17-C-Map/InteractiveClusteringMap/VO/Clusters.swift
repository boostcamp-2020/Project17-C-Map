//
//  Clusters.swift
//  InteractiveClusteringMap
//
//  Created by Seungeon Kim on 2020/11/30.
//

import Foundation

struct Clusters {
    let items: [Cluster]
    
    init(items: [Cluster]) {
        self.items = items
    }
    
    subscript(index: Int) -> Cluster? {
        return items[safe: index]
    }
    
    func silhouette() -> Double {
        guard items.count != 0 else {
            return 0
        }
        return AverageSilhouetteCalculator.caculateAverageClusters(clusters: items)
    }
}
