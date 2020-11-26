//
//  KMeansClustering.swift
//  InteractiveClusteringMap
//
//  Created by Oh Donggeon on 2020/11/25.
//

import Foundation
import NMapsMap.NMapsGeometry

class KMeansClustering {
    
    private var clusters: [Cluster] = []
    private let k: Int
    
    init(k: Int) {
        self.k = k
    }
    
    /// points에 대한 centroid를 계속 계산하여 points의 classification에 변화가 없을 시 cluster를 반환합니다.
    ///
    /// - Parameters:
    ///   - points: 모든 좌표 값
    ///   - centroids: 초기 중심 값
    /// - Returns: 중심이 되는 클러스터를 반환합니다.
    func trainCenters(_ points: [Coordinate], centroids: [Coordinate]) -> [Cluster] {
        // 초기화 한 센터에 대한 points를 classification 해준다.
        var clusters = classify(points, from: centroids)
        var isChanged = true
        
        repeat {
            // 센터를 움직인 후 classification 해준다.
            var movedCenters: [Coordinate] = []
            
            clusters.forEach {
                movedCenters.append($0.updateCenter)
            }
            let movedClusters = classify(points, from: movedCenters)
            
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
        
        centers.forEach {
            clusters.append(Cluster(center: $0, coordinates: []))
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
        // x와 센터들 중 가장 가까운 거리를 가지는 center의 index를 구함
        for (idx, center) in centers.enumerated() {
            let dist = point.distanceTo(center)
            if dist < nearestDist {
                minIndex = idx
                nearestDist = dist
            }
        }
        
        return minIndex
    }
    
}
