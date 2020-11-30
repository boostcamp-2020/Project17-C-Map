//
//  RandomCetroidGenerator.swift
//  InteractiveClusteringMap
//
//  Created by Seungeon Kim on 2020/11/28.
//

import Foundation

struct RandomCentroidGenerator: CentroidGeneratable {
    
    private let lats: ClosedRange<Double>
    private let lngs: ClosedRange<Double>
    
    init(rangeOfLat: ClosedRange<Double>, rangeOfLng: ClosedRange<Double>) {
        self.lats = rangeOfLat
        self.lngs = rangeOfLng
    }
    
    func centroids(k: Int) -> [Coordinate] {
        var centroids: [Coordinate] = []
        for _ in 0..<k {
            let cluster = Coordinate.randomGenerate(rangeOfLat: lats, rangeOfLng: lngs)
            centroids.append(cluster)
        }
        
        return centroids
    }
        
}
