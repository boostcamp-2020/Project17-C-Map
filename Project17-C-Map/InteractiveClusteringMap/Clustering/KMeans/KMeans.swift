//
//  KMeans.swift
//  InteractiveClusteringMap
//
//  Created by Oh Donggeon on 2020/11/25.
//

import Foundation

protocol CentroidGeneratable {
    func centroids(k: Int) -> [Coordinate]
}

struct KMeans {
    
    private let k: Int
    private let centroidable: CentroidGeneratable
    private let option: CompleteOption
    private let coverage: Double = 1.0
    
    init(k: Int, centroidable: CentroidGeneratable, option: CompleteOption) {
        self.k = k
        self.centroidable = centroidable
        self.option = option
    }
    
    func start(coordinate: [Coordinate], completion: @escaping ([Cluster]) -> Void) {
        switch option {
        case .distance:
            completion(trainCenters(coordinate, convergeDistance: coverage))
        case .state:
            completion(trainCenters(coordinate))
        }
    }
    
    /// points에 대한 centroid를 계속 계산하여 centroid가 이동한 총 거리가
    /// convergeDistance 이하로 움직일 경우 cluster를 반환합니다.
    ///
    /// - Parameters:
    ///   - points: 모든 좌표 값
    ///   - initialCentroids: 초기 중심 값
    ///   - convergeDistance: 바뀐 Clusters가 움직인 총 거리가 convergeDistance 보다 작을경우 Cluster 반환
    /// - Returns: 중심이 되는 클러스터를 반환합니다.
    private func trainCenters(_ points: [Coordinate], convergeDistance: Double) -> [Cluster] {
        let initialCentroids = centroidable.centroids(k: k)
        var clusters: [Cluster]
        var beforeCenters = initialCentroids
        var totalMoveDist = Double.zero
        
        repeat {
            clusters = classify(points, from: beforeCenters)
            totalMoveDist = Double.zero
            
            let movedCenters = clusters.map { $0.center }
            
            for (index, center) in beforeCenters.enumerated() {
                totalMoveDist += center.distanceTo(movedCenters[index])
            }
            beforeCenters = movedCenters
            
        } while totalMoveDist < convergeDistance
        
        return clusters
    }
    
    /// points에 대한 centroid를 계속 계산하여 points의 classification에 변화가 없을 시 cluster를 반환합니다.
    ///
    /// - Parameters:
    ///   - points: 모든 좌표 값
    ///   - initialCentroids: 초기 중심 값
    /// - Returns: 중심이 되는 클러스터를 반환합니다.
    private func trainCenters(_ points: [Coordinate]) -> [Cluster] {
        let initialCentroids: [Coordinate] = centroidable.centroids(k: k)
        var clusters = classify(points, from: initialCentroids)
        var isChanged = true
        
        repeat {
            let centers = clusters.map { $0.center }
            let movedClusters = classify(points, from: centers)
            
            if clusters.hashValue == movedClusters.hashValue {
                isChanged = false
            }
            clusters = movedClusters
            
        } while isChanged
        
        return clusters
    }
    
    /// 각 points에 대해 가장 가까운 center로 points를 분류하여 cluster 객체를 반환합니다.
    ///
    /// - Parameters:
    ///   - points: 분류할 모든 좌표
    ///   - centers: 현재 중심인 센터
    /// - Returns: 분류한 points를 가지는 clusters를 리턴한다. (Cluster)
    private func classify(_ points: [Coordinate], from centers: [Coordinate]) -> [Cluster] {
        var clusters = [Cluster](repeating: Cluster(coordinates: [], boundingBox: BoundingBox(topRight: Coordinate(x: 0, y: 0), bottomLeft: Coordinate(x: 0, y: 0))), count: centers.count)
        
        points.forEach { point in
            let centerIndex = indexOfNearestCenter(point, centers: centers)
            
            clusters[centerIndex].coordinates.append(point)
        }
        
        return clusters
    }
    
    /// point 와 센터들 중 가장 가까운 센터의 index를 반환합니다.
    ///
    /// - Parameters:
    ///   - point: 센터들과 비교하려는 점
    ///   - centers: 센터들
    /// - Returns: 가장 가까운 센터의 index를 반환
    private func indexOfNearestCenter(_ point: Coordinate, centers: [Coordinate]) -> Int {
        var nearestDist = Double.greatestFiniteMagnitude
        var minIndex = 0
        
        for (idx, center) in centers.enumerated() {
            let dist = point.distanceTo(center)
            guard dist < nearestDist else {
                continue
            }
            minIndex = idx
            nearestDist = dist
        }
        
        return minIndex
    }
    
}

extension KMeans {
    
    enum CompleteOption {
        case distance, state
    }
    
}
