//
//  KMeansClustering.swift
//  InteractiveClusteringMap
//
//  Created by Oh Donggeon on 2020/11/25.
//

import Foundation

class KMeansClustering {
    
    private var clusters: [Cluster] = []
    private let k: Int
    
    init(k: Int) {
        self.k = k
    }
    
    /// points에 대한 centroid를 계속 계산하여 centroid가 이동한 총 거리가
    /// convergeDistance 이하로 움직일 경우 cluster를 반환합니다.
    ///
    /// - Parameters:
    ///   - points: 모든 좌표 값
    ///   - initialCentroids: 초기 중심 값
    ///   - convergeDistance: 바뀐 Clusters가 움직인 총 거리가 convergeDistance 보다 작을경우 Cluster 반환
    /// - Returns: 중심이 되는 클러스터를 반환합니다.
    func trainCenters(_ points: [Coordinate], initialCentroids: [Coordinate], convergeDistance: Double) -> [Cluster] {
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
    func trainCenters(_ points: [Coordinate], initialCentroids: [Coordinate]) -> [Cluster] {
        // 초기화 한 센터에 대한 points를 classification 해준다.
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
    
    /// - Parameters:
    ///   - points: 분류할 모든 좌표
    ///   - centers: 현재 중심인 센터
    /// - Returns: 분류한 points를 가지는 clusters를 리턴한다. (Cluster)
    func classify(_ points: [Coordinate], from centers: [Coordinate]) -> [Cluster] {
        var clusters: [Cluster] = []
        
        for _ in 0..<centers.count {
            clusters.append(Cluster(coordinates: []))
        }
        
        points.forEach {
            let classIndex = indexOfNearestCenter($0, centers: centers)
            clusters[classIndex].coordinates.append($0)
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