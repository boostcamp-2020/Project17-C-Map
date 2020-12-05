//
//  QuadTreeClusteringService.swift
//  InteractiveClusteringMap
//
//  Created by eunjeong lee on 2020/11/25.
//
// 처음 보여줘야할 영역 (한반도 기준 // 데이터 갯수) 33 ~ 43, 124 ~ 132
// 그 영역을 몇개로 분할할 것인가 // 10:8 = 0.5:0.4 // 20 * 20
//


import Foundation

final class QuadTreeClusteringService {
    
    private let poiService: POIServicing
    private var quadTreeWithBoundary: [BoundingBox: QuadTree] = [: ]
    
    init(poiService: POIServicing) {
        self.poiService = poiService
        setupTrees()
    }
    
    // 클러스터링 Task를 WorkItem으로 반환
    private func clusteringWorkItem(target: BoundingBox,
                                    zoomLevel: Double,
                                    completion: @escaping (([Cluster]) -> Void)) -> DispatchWorkItem {
        DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            let clusters = self.clustering(target: target, zoomLevel: zoomLevel)
            completion(clusters)
        }
    }
    
    //한반도 기준 트리를 나눠서 관리 20 x 20 = 400개
    private func setupTrees() {
        let width = BoundingBox.korea.topRight.x - BoundingBox.korea.bottomLeft.x
        let height = BoundingBox.korea.topRight.y - BoundingBox.korea.bottomLeft.y

        for row in 1...Count.split {
            for column in 1...Count.split {
                DispatchQueue.global().async { [weak self] in
                    guard let self = self else { return }
                    let left = BoundingBox.korea.bottomLeft.x + (width / Double(Count.split) * Double(row - 1))
                    let right = BoundingBox.korea.bottomLeft.x + (width / Double(Count.split)) * Double(row)
                    let top = BoundingBox.korea.bottomLeft.y + (height / Double(Count.split) * Double(column))
                    let bottom = BoundingBox.korea.bottomLeft.y + (height / Double(Count.split) * Double(column - 1))
                    
                    let boundingBox = BoundingBox(topRight: Coordinate(x: right, y: top), bottomLeft: Coordinate(x: left, y: bottom))
                    
                    self.makeQuadTree(boundingBox: boundingBox)
                }
            }
        }
    }
    
    // POIServicing으로 부터 해당 영역의 POI 데이터를 불러온다.
    // 해당 영역의 데이터들로 quadTree를 생성한다.
    private func makeQuadTree(boundingBox: BoundingBox) {
        poiService.fetch(bottomLeft: boundingBox.bottomLeft, topRight: boundingBox.topRight) { coordinates in
            guard !coordinates.isEmpty else { return }
            
            let tree = QuadTree(boundingBox: boundingBox, nodeCapacity: Capacity.node)
            self.quadTreeWithBoundary[boundingBox] = tree
            self.insertCoordinatesAsync(quadTree: tree, coordinates: coordinates)
        }
    }
        
    private func insertCoordinatesAsync(quadTree: QuadTree, coordinates: [Coordinate]) {
        DispatchQueue.global().async {
            coordinates.forEach {
                quadTree.insert(coordinate: $0)
            }
        }
    }
    
    //target에 속한 쿼드트리를 찾아서 반환한다.
    private func quadTrees(target: BoundingBox) -> [QuadTree] {
        let filtered = quadTreeWithBoundary.filter { $0.key.isOverlapped(with: target) }
        return filtered.map { $0.value }
    }
    
    //cluster 결과값을 반환한다.
    private func clustering(target: BoundingBox, zoomLevel: Double) -> [Cluster] {
        let quadTrees = self.quadTrees(target: target)
        return excuteClustering(quadTrees: quadTrees, boundingBox: target, zoomLevel: zoomLevel)
    }
    
    // TODO: 추후 workItem 클러스터링 한개 별로 병렬로 넣는것 vs 한번에 처리하는 것 성능 비교
    // 한 클러스터 영역 크기를 정해, 전체 BoundingBox(클러스터 해야되는 범위 전체)를 순서대로 순회하면서 Clustering한다.
    private func excuteClustering(quadTrees: [QuadTree],
                                  boundingBox: BoundingBox,
                                  zoomLevel: Double) -> [Cluster] {
        var result = [Cluster]()
        
        let widthCount = clusterWidthCount(zoomLevel: zoomLevel)
        let heightCount = Int(Double(widthCount) / boundingBox.topRight.ratio(other: boundingBox.bottomLeft))
        let clusterRegionWidth: Double = (boundingBox.topRight.x - boundingBox.bottomLeft.x) / Double(widthCount)
        let clusterRegionHeight: Double = (boundingBox.topRight.y - boundingBox.bottomLeft.y) / Double(heightCount)
        
        var (bottomLeftX, bottomLeftY) = (boundingBox.bottomLeft.x, boundingBox.bottomLeft.y)
        
        (0..<heightCount).forEach { _ in
            (0..<widthCount).forEach { _ in
                defer {
                    bottomLeftX += clusterRegionWidth
                }
                let topRight = Coordinate(x: bottomLeftX + clusterRegionWidth, y: bottomLeftY + clusterRegionHeight)
                let bottomLeft = Coordinate(x: bottomLeftX, y: bottomLeftY)
                let region = BoundingBox(topRight: topRight, bottomLeft: bottomLeft)
                
                let foundCoordinates = quadTrees.flatMap {
                    $0.findCoordinates(region: region)
                }
                guard !foundCoordinates.isEmpty else { return }
                result.append(Cluster(coordinates: foundCoordinates))
            }
            
            bottomLeftY += clusterRegionHeight
            bottomLeftX = boundingBox.bottomLeft.x
        }
        return result
    }
    
    private func clusterWidthCount(zoomLevel: Double) -> Int {
        Int(min((zoomLevel / 2.5), 8))
    }
    
}

extension QuadTreeClusteringService: ClusteringServicing {
    
    func execute(coordinates: [Coordinate]?,
                 boundingBox: BoundingBox,
                 zoomLevel: Double,
                 completionHandler: @escaping (([Cluster]) -> Void)) {
        
        let workItem = clusteringWorkItem(target: boundingBox, zoomLevel: zoomLevel, completion: completionHandler)
        DispatchQueue.global().async(execute: workItem)
    }
    
    // cancel시 진행중인 workItem은 취소가 안된다고 함..
    // 어떻게 할지 공부 더 필요
    func cancel() {}
    
}

private extension QuadTreeClusteringService {
    
    enum Capacity {
        static let node: Int = 25
    }
    
    enum Name {
        static let quadTreeClusteringQueue: String = "quadTreeClusteringQueue"
    }
    
    enum Count {
        static let split = 20
    }
    
}
