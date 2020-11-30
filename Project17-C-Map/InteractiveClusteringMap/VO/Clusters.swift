//
//  Clusters.swift
//  InteractiveClusteringMap
//
//  Created by Seungeon Kim on 2020/11/30.
//

import Foundation

struct Clusters {
    let items: [Cluster]
    var silhouette: Double = 0.0
    
    init(items: [Cluster]) {
        self.items = items
        self.silhouette = calculateSilhouette()
    }
    
    subscript(index: Int) -> Cluster? {
        if index > (items.count - 1) { return nil }
        
        return items[index]
    }
    
    private func calculateSilhouette() -> Double {
        guard items.count != 0 else {
            return 0
        }
        return AverageSilhouetteCalculator.caculateAverageClusters(clusters: items)
    }
}
