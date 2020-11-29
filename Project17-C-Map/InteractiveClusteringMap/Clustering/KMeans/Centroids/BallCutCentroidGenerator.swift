//
//  BallCutCentroidGenerator.swift
//  InteractiveClusteringMap
//
//  Created by Seungeon Kim on 2020/11/28.
//

import Foundation

final class BallCutCentroidGenerator: CentroidCreatable {
    
    private let coverage: Double
    private let k: Int
    private let points: [Coordinate]
    private let mutiplier: Int = 5
    
    init(k: Int, coverage: Double, coordinates: [Coordinate]) {
        self.k = k
        self.coverage = coverage
        self.points = coordinates
    }
    
    func centroids() -> [Coordinate] {
        return  recursiveClassify(k: k, coordinates: points)
    }
    
    private func recursiveClassify(k: Int, coordinates: [Coordinate]) -> [Coordinate] {
        var coordinates = coordinates
        let container = createContainer(k: k, coordinates: coordinates)
        var centroids: [Coordinate] = pickCentroids(k: k, distance: coverage, container: container)
        
        guard centroids.count == k else { return centroids }
        
        for coordinate in container {
            guard let index = coordinates.firstIndex(of: coordinate) else {
                return []
            }
            coordinates.remove(at: index)
        }
        
        centroids += recursiveClassify(k: k - centroids.count + 1, coordinates: coordinates)
        return centroids
    }
    
    private func createContainer(k: Int, coordinates: [Coordinate]) -> [Coordinate] {
        var coordinates = coordinates
        var container: [Coordinate] = []
        let count = k * mutiplier
        
        for _ in 0..<count {
            guard let coordinate = coordinates.randomElement(),
                  let index = coordinates.firstIndex(of: coordinate)
            else {
                return []
            }
            container.append(coordinate)
            coordinates.remove(at: index)
        }
        
        return container
    }
    
    private func pickCentroids(k: Int, distance: Double, container: [Coordinate]) -> [Coordinate] {
        var centroids: [Coordinate] = []
        var container = container
        
        for _ in 0..<k {
            guard let centroid = container.randomElement() else {
                return centroids
            }
            
            container = container.filter { centroid.distanceTo($0) >= distance }
            centroids.append(centroid)
        }
        
        return centroids
    }
    
}