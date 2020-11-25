//
//  KMeansClustering.swift
//  InteractiveClusteringMap
//
//  Created by Oh Donggeon on 2020/11/25.
//

import Foundation

class KMeans<Label: Hashable> {
    
    let numCenters: Int
    let labels: [Label]
    private(set) var centroids: [Coordinate] = []
    
    init(labels: [Label]) {
        assert(labels.count > 1, "Exception: KMeans with less than 2 centers.")
        self.labels = labels
        self.numCenters = labels.count
    }
    
    /// - Parameters:
    ///   - points: 데이터
    ///   - convergeDistance:
    /// - Returns: clustering 된 centroids 반환
    func trainCenters(_ points: [Coordinate], convergeDistance: Double) -> [Coordinate] {
        // 1. 초기 센터를 구한다.
        // 2. points 마다 가장 가까운 센터를 찾아서 point를 센터마다 분리한다.
        // 3. 분리한 points의 평균 지점을 구한다. (points의 모든 값 / points 갯수)
        // 4. 센터가 움직인 거리를 모두 더해준다. (centerMoveDist)
        // 5. 움직인 거리가 convergeDistance 이하까지 계속하여 계산한다. (reqeat while)
        
        let zeroVector = Vector([Double](repeating: 0, count: points[0].length))
        
        // Randomly take k objects from the input data to make the initial centroids.
        var centers = reservoirSample(points, k: numCenters)
        var centerMoveDist = 0.0
        
        repeat {
            // This array keeps track of which data points belong to which centroids.
            var classification: [[Vector]] = .init(repeating: [], count: numCenters)
            
            // For each data point, find the centroid that it is closest to.
            for p in points {
                let classIndex = indexOfNearestCenter(p, centers: centers)
                classification[classIndex].append(p)
            }
            
            // Take the average of all the data points that belong to each centroid.
            // This moves the centroid to a new position.
            let newCenters = classification.map { assignedPoints in
                assignedPoints.reduce(zeroVector, +) / Double(assignedPoints.count)
            }
            
            // Find out how far each centroid moved since the last iteration. If it's
            // only a small distance, then we're done.
            centerMoveDist = 0.0
            for idx in 0..<numCenters {
                centerMoveDist += centers[idx].distanceTo(newCenters[idx])
            }
            
            centers = newCenters
        } while centerMoveDist > convergeDistance
        
        centroids = centers
    }
    
    func trainCenters(_ points: [Coordinate], initialCenters: [Coordinate]) -> [Coordinate] {
        // 1. points 마다 가장 가까운 센터를 찾아서 point를 센터마다 분리한다.
        // 2. 분리한 points가 이전과 변했는지 확인한다.
        // 2-1. 변한 경우, 다시 한번 클러스터링 한다.
        // 2-2. 변하지 않은 경우, 해당 센터를 리턴한다.
        
        // 초기화 한 센터에 대한 points를 classification 해준다.
        let centers = classify(points, centers: initialCenters)
        
        // 어떤 point의 변화가 있는 경우 true, 없으면 false
        // false 일 경우 한번 더 classification 한 후
        let isChanged = true
        
        repeat {
            // 센터를 움직인 후 classification 해준다.
            let movedCenters = move(centers: centers)
            
        } while isChanged
        
        return centers
    }

    /// - Parameters:
    ///   - points: 분류할 좌표 (Coord)
    ///   - centers: 현재 중심인 센터 (Coord)
    /// - Returns: 분류한 points를 가지는 clusters를 리턴한다. (Cluster)
    func classify(points: [Coordinate], from centers: [Coordinate]) -> [Cluster] {
        let clusters: [Cluster] = []
        
        for center in centers {
            let cluster = Cluster(x: center.x, y: center.y)
            clusters.append(cluster)
        }
        
        for point in points {
            let classIndex = indexOfNearestCenter(point, centers: centers)
            clusters[classIndex].append(point)
        }
        
        return clusters
    }
    
    private func move(centers: [Cluster]) -> [Cluster] {
        // 새로운 센터를 리턴해줌 (points의 값을 모두 더해주고 points의 갯수로 나눠준다.)
        return centers.map { center in
            center.point.reduce(.zero, +) / Double(center.point.count)
        }
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
            let dist = point.distanceTo(center) // 함수를 구현해야 함 (이미 있음)
            if dist < nearestDist {
                minIndex = idx
                nearestDist = dist
            }
        }
        // 포인트가 자신이 어디 center로 분류되는지 알고 있게 하기 위해서 center의 index를 갖고 있는다.
        x.nearestCenter = minIndex
        
        return minIndex
    }
    
}
