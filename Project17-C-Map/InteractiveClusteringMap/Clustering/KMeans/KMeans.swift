//
//  KMeans.swift
//  InteractiveClusteringMap
//
//  Created by Oh Donggeon on 2020/11/25.
//

import Foundation

final class KMeans {
    
    private let k: Int
    
    init(k: Int) {
        self.k = k
    }
    
    func initializeBallCutCentroids(k: Int,
                                     coverage: Double,
                                     coordinates: [Coordinate]) -> [Coordinate] {
        var coordinates = coordinates
        let container = createContainer(k: k, coordinates: coordinates)
        var centroids += pickCentroids(k: k, distance: coverage, container: container)
        
        if centroids.count != k {
            for coordinate in container {
                guard let index = coordinates.firstIndex(of: coordinate) else {
                    return []
                }
                coordinates.remove(at: index)
            }
            
            centroids += initializeBallCutCentroids(k: k - centroids.count + 1, coverage: coverage, coordinates: coordinates)
        }
        
        return centroids
    }
    
    private func createContainer(k: Int, coordinates: [Coordinate], mutiplier: Int = 5) -> [Coordinate] {
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
            
            var removeCoordinates: [Coordinate] = []
            
            container.forEach { coordinate in
                if centroid.distanceTo(coordinate) <= distance {
                    removeCoordinates.append(coordinate)
                }
            }
            
            container = container.filter { !removeCoordinates.contains($0) }
            centroids.append(centroid)
        }
        
        return centroids
    }
    
    func initializeRandomCentroids(rangeOfLat lats: ClosedRange<Double>,
                         rangeOfLng lngs: ClosedRange<Double>) -> [Coordinate] {
        var centroids: [Coordinate] = []
        for _ in 0..<k {
            let cluster = Coordinate.randomGenerate(rangeOfLat: lats, rangeOfLng: lngs)
            centroids.append(cluster)
        }
        
        return centroids
    }
    
    func initializeScreenCentroids(topLeft: Coordinate, bottomRight: Coordinate) -> [Coordinate] {
        let center = (topLeft + bottomRight) / 2.0
        let boundary = Coordinate(x: bottomRight.x - center.x, y: topLeft.y - center.y)
        let pivot = center.findTheta(vertex: Coordinate(x: bottomRight.x, y: topLeft.y))
        
        let increase = Degree.turn / Double(k)
        var angle = increase
        var coords: [Coordinate] = []
        
        for _ in 0..<k {
            let quadrant = Quadrant.findQuadrant(angle: angle)
            let modulus = angle.truncatingRemainder(dividingBy: Degree.right)
            
            if modulus == 0 {
                let distance = boundary / 2
                let coord =  quadrant.degree(center: center, boundary: distance)
                coords.append(coord)
            } else {
                let theta = quadrant.theta(angle: modulus)
                let radian = theta * .pi / Degree.straight
                var x: Double
                var y: Double
                
                if theta > pivot {
                    y = boundary.y
                    x = y / tan(radian)
                } else {
                    x = boundary.x
                    y = tan(radian) * x
                }
                let distance = Coordinate(x: x, y: y) / 2
                let coord = quadrant.convertToCoordinate(center: center, distance: distance)
                coords.append(coord)
            }
            angle += increase
        }
        
        return coords
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
    
    /// 각 points에 대해 가장 가까운 center로 points를 분류하여 cluster 객체를 반환합니다.
    ///
    /// - Parameters:
    ///   - points: 분류할 모든 좌표
    ///   - centers: 현재 중심인 센터
    /// - Returns: 분류한 points를 가지는 clusters를 리턴한다. (Cluster)
    private func classify(_ points: [Coordinate], from centers: [Coordinate]) -> [Cluster] {
        var clusters = [Cluster](repeating: Cluster(coordinates: []), count: centers.count)
        
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
