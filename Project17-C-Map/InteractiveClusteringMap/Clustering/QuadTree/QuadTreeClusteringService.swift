//
//  QuadTreeClusteringService.swift
//  InteractiveClusteringMap
//
//  Created by eunjeong lee on 2020/11/25.
//

import Foundation

final class QuadTreeClusteringService {
    
    private let coordinates: [Coordinate]
    private let quadTree: QuadTree
    private let queue = DispatchQueue(label: Name.quadTreeClusteringQueue, qos: .userInitiated)
    private var workingClusteringWorkItem: DispatchWorkItem?
    
    private lazy var insertWorkItem = DispatchWorkItem { [weak self] in
        guard let self = self else { return }
        self.coordinates.forEach {
            self.quadTree.insert(coordinate: $0)
        }
        // QuadTree boundingbox를 카메라 boundingbox로 했을 때와, minmax를 구해서 했을 때 비교하려고 만듬
        self.updateQuadTreeBoundingBox()
    }
    
    init(coordinates: [Coordinate], boundingBox: BoundingBox) {
        self.coordinates = coordinates
        quadTree = QuadTree(boundingBox: boundingBox, nodeCapacity: Capacity.node)
        insertCoordinatesAsync()
    }
    
    private func insertCoordinatesAsync() {
        queue.async(execute: insertWorkItem)
    }
    
    private func clusteringWorkItem(
        boundingBox: BoundingBox,
        zoomLevel: Double,
        completionHandler: @escaping ([Cluster]) -> Void) -> DispatchWorkItem {
        DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            let clusters = self.clustering(boundingBox: boundingBox, zoomLevel: zoomLevel)
            completionHandler(clusters)
        }
    }
    
    private func updateQuadTreeBoundingBox() {
        quadTree.updateBoundingBox()
    }
    
    // TODO: 추후 workItem 클러스터링 한개 별로 병렬로 넣는것 vs 한번에 처리하는 것 성능 비교
    // 한 클러스터 영역 크기를 정해, 전체 BoundingBox(클러스터 해야되는 범위 전체)를 순서대로 순회하면서 Clustering한다.
    private func clustering(boundingBox: BoundingBox,
                            zoomLevel: Double) -> [Cluster] {
        var result = [Cluster]()
        
        let widthCount = clusterWidthCount(zoomLevel: zoomLevel)
        let heightCount = Int(Double(widthCount) / boundingBox.topRight.ratio(other: boundingBox.bottomLeft))
        let clusterRegionWidth: Double = (boundingBox.topRight.x - boundingBox.bottomLeft.x) / Double(widthCount)
        let clusterRegionHeight: Double = (boundingBox.topRight.y - boundingBox.bottomLeft.y) / Double(heightCount)
        
        var (bottomLeftX, bottomLeftY) = (boundingBox.bottomLeft.x, boundingBox.bottomLeft.y)

        while bottomLeftY < boundingBox.topRight.y {
            while bottomLeftX < boundingBox.topRight.x {
                defer {
                    bottomLeftX += clusterRegionWidth
                }
                let topRight = Coordinate(x: bottomLeftX + clusterRegionWidth, y: bottomLeftY + clusterRegionHeight)
                let bottomLeft = Coordinate(x: bottomLeftX, y: bottomLeftY)
                let region = BoundingBox(topRight: topRight, bottomLeft: bottomLeft)
                
                let foundCoordinates = quadTree.findCoordinates(region: region)
                guard !foundCoordinates.isEmpty else { continue }
                result.append(Cluster(coordinates: foundCoordinates))
            }
            
            bottomLeftY += clusterRegionHeight
            bottomLeftX = boundingBox.bottomLeft.x
        }
        return result
    }
    
    private func clusterWidthCount(zoomLevel: Double) -> Int {
        Int(min((zoomLevel / 3), 4))
    }

}

extension QuadTreeClusteringService: ClusteringServicing {
    
    func execute(coordinates: [Coordinate]?,
                 boundingBox: BoundingBox,
                 zoomLevel: Double,
                 completionHandler: @escaping (([Cluster]) -> Void)) {
        
        queue.async { [weak self] in
            guard let self = self else { return }
            self.workingClusteringWorkItem?.cancel()
            self.workingClusteringWorkItem = self.clusteringWorkItem(boundingBox: boundingBox,
                                                                     zoomLevel: zoomLevel,
                                                                     completionHandler: completionHandler)
            self.workingClusteringWorkItem?.perform()
        }
    }
    
    // cancel시 진행중인 workItem은 취소가 안된다고 함..
    // 어떻게 할지 공부 더 필요
    func cancel() {
//        insertWorkItem.cancel()
//        workingClusteringWorkItem?.cancel()
    }
    
}

private extension QuadTreeClusteringService {
    
    enum Capacity {
        static let node: Int = 25
    }
    
    enum Name {
        static let quadTreeClusteringQueue: String = "quadTreeClusteringQueue"
    }
    
}
