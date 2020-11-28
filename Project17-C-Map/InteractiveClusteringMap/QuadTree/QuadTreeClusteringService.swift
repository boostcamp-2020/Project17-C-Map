//
//  QuadTreeClusteringService.swift
//  InteractiveClusteringMap
//
//  Created by eunjeong lee on 2020/11/25.
//

import Foundation

protocol ClusteringServicing {
    
    func execute(completionHandler: @escaping (([Cluster]) -> Void))
    func cancel()
    
}

final class QuadTreeClusteringService {
    
    private let coordinates: [Coordinate]
    private let quadTree: QuadTree
    private var boundingBox: BoundingBox
    private let queue = DispatchQueue(label: Name.quadTreeClusteringQueue, qos: .userInitiated)
    private var workingClusteringWorkItem: DispatchWorkItem?
    private var zoomLevel: Double
    private var clusterWidthCount: Int {
        Int(min((zoomLevel / 3), 4))
    }
    
    private lazy var insertWorkItem = DispatchWorkItem { [weak self] in
        self?.coordinates.forEach {
            self?.quadTree.insert(coordinate: $0)
        }
//        QuadTree boundingbox를 카메라 boundingbox로 했을 때와, minmax를 구해서 했을 때 비교하려고 만듬
        self?.updateQuadTreeBoundingBox()
    }
    
    init(coordinates: [Coordinate], boundingBox: BoundingBox, zoomLevel: Double) {
        self.coordinates = coordinates
        self.boundingBox = boundingBox
        self.zoomLevel = zoomLevel
        quadTree = QuadTree(boundingBox: boundingBox, nodeCapacity: Capacity.node)
        insertCoordinates()
    }

    func update(boundingBox: BoundingBox, zoomLevel: Double) {
        self.boundingBox = boundingBox
        self.zoomLevel = zoomLevel
    }
    
    private func insertCoordinates() {
        queue.async(execute: insertWorkItem)
    }
    
    private func clusteringWorkItem(
        completionHandler: @escaping ([Cluster]) -> Void) -> DispatchWorkItem {
        DispatchWorkItem { [weak self] in
            let clusters = self?.clustering()
            completionHandler(clusters ?? [])
        }
    }
    
    private func updateQuadTreeBoundingBox() {
        quadTree.updateBoundingBox()
    }
    
    // TODO: 추후 workItem 클러스터링 한개 별로 병렬로 넣는것 vs 한번에 처리하는 것 성능 비교
    // 한 클러스터 영역 크기를 정해, 전체 BoundingBox(클러스터 해야되는 범위 전체)를 순서대로 순회하면서 Clustering한다.
    private func clustering() -> [Cluster] {
        var result = [Cluster]()
        
        let widthCount: Int = clusterWidthCount
        let heightCount: Int = Int(Double(widthCount) / boundingBox.ratio)
        let clusterRegionWidth: Double = (boundingBox.topRight.x - boundingBox.bottomLeft.x) / Double(widthCount)
        let clusterRegionHeight: Double = (boundingBox.topRight.y - boundingBox.bottomLeft.y) / Double(heightCount)
        
        var x = boundingBox.bottomLeft.x
        var y = boundingBox.bottomLeft.y

        while y < boundingBox.topRight.y {
            while x < boundingBox.topRight.x {
                defer {
                    x += clusterRegionWidth
                }
                let topRight = Coordinate(x: x + clusterRegionWidth, y: y + clusterRegionHeight)
                let bottomLeft = Coordinate(x: x, y: y)
                let region = BoundingBox(topRight: topRight, bottomLeft: bottomLeft)
                
                let foundCoordinates = quadTree.findCoordinates(region: region)
                guard !foundCoordinates.isEmpty else { continue }
                result.append(Cluster(coordinates: foundCoordinates))
            }
            
            y += clusterRegionHeight
            x = boundingBox.bottomLeft.x
        }
        return result
    }

}

extension QuadTreeClusteringService: ClusteringServicing {
    
    func execute(completionHandler: @escaping (([Cluster]) -> Void)) {
        
        queue.async { [weak self] in
            self?.workingClusteringWorkItem?.cancel()
            self?.workingClusteringWorkItem = self?.clusteringWorkItem(completionHandler: completionHandler)
            self?.workingClusteringWorkItem?.perform()
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
