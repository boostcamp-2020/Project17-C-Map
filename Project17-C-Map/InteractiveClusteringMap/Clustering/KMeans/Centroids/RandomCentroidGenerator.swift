//
//  RandomCetroidGenerator.swift
//  InteractiveClusteringMap
//
//  Created by Seungeon Kim on 2020/11/28.
//

import Foundation

final class RandomCentroidGenerator: CentroidCreatable {
    
    private let k: Int
    private let lats: ClosedRange<Double>
    private let lngs: ClosedRange<Double>
    
    init(k: Int, rangeOfLat: ClosedRange<Double>, rangeOfLng: ClosedRange<Double>) {
        self.k = k
        self.lats = rangeOfLat
        self.lngs = rangeOfLng
    }
    
    func centroids() -> [Coordinate] {
        var centroids: [Coordinate] = []
        for _ in 0..<k {
            let cluster = Coordinate.randomGenerate(rangeOfLat: lats, rangeOfLng: lngs)
            centroids.append(cluster)
        }
        
        return centroids
    }
        
}
