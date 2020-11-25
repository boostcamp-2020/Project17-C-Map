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

    /// - Parameters:
    ///   - points: 데이터
    ///   - convergeDistance:
    /// - Returns: clustering 된 centroids 반환
    func trainCenters(_ points: [Coordinate], convergeDistance: Double) -> [Coordinate] {
        //        // 1. 초기 센터를 구한다.
        //        // 2. points 마다 가장 가까운 센터를 찾아서 point를 센터마다 분리한다.
        //        // 3. 분리한 points의 평균 지점을 구한다. (points의 모든 값 / points 갯수)
        //        // 4. 센터가 움직인 거리를 모두 더해준다. (centerMoveDist)
        //        // 5. 움직인 거리가 convergeDistance 이하까지 계속하여 계산한다. (reqeat while)
        //
        //        let zeroVector = Vector([Double](repeating: 0, count: points[0].length))
        //
        //        // Randomly take k objects from the input data to make the initial centroids.
        //        var centers = reservoirSample(points, k: numCenters)
        //        var centerMoveDist = 0.0
        //
        //        repeat {
        //            // This array keeps track of which data points belong to which centroids.
        //            var classification: [[Vector]] = .init(repeating: [], count: numCenters)
        //
        //            // For each data point, find the centroid that it is closest to.
        //            for p in points {
        //                let classIndex = indexOfNearestCenter(p, centers: centers)
        //                classification[classIndex].append(p)
        //            }
        //
        //            // Take the average of all the data points that belong to each centroid.
        //            // This moves the centroid to a new position.
        //            let newCenters = classification.map { assignedPoints in
        //                assignedPoints.reduce(zeroVector, +) / Double(assignedPoints.count)
        //            }
        //
        //            // Find out how far each centroid moved since the last iteration. If it's
        //            // only a small distance, then we're done.
        //            centerMoveDist = 0.0
        //            for idx in 0..<numCenters {
        //                centerMoveDist += centers[idx].distanceTo(newCenters[idx])
        //            }
        //
        //            centers = newCenters
        //        } while centerMoveDist > convergeDistance
        //
        //        centroids = centers

        return []
    }

    // 2. 분리한 points가 이전과 변했는지 확인한다.
    // 2-1. 변한 경우, 다시 한번 클러스터링 한다.
    // 2-2. 변하지 않은 경우, 해당 센터를 리턴한다.
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
