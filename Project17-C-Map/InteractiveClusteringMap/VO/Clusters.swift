//
//  Clusters.swift
//  InteractiveClusteringMap
//
//  Created by Seungeon Kim on 2020/11/30.
//

import Foundation

protocol SilhouetteCalculatable {
    func silhouette() -> Double
}

struct Clusters {
    let items: [Cluster]
    
    init(items: [Cluster]) {
        self.items = items
    }
    
    subscript(index: Int) -> Cluster? {
        return items[safe: index]
    }
}

extension Clusters: SilhouetteCalculatable {
    func silhouette() -> Double {
        guard items.count != 0 else {
            return 0
        }
        
        return AverageSilhouetteCalculator.calculateAverageClusters(clusters: items)
    }
}
