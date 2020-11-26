//
//  QuadTreeClusteringService.swift
//  InteractiveClusteringMap
//
//  Created by eunjeong lee on 2020/11/25.
//

import Foundation

protocol ClusteringServicing {
    
    func execute(successHandler: @escaping (([Cluster]) -> Void), failureHandler: ((NSError) -> Void)?)
    func cancel()
    
}

class QuadTreeClusteringService {
    
    // 외부에서 카메라 위치 바뀌면 어떻게 할지 생각
    private var coordinates: [Coordinate]
    private let quadTree: QuadTree
    private let boundingBox: BoundingBox
    private let queue = DispatchQueue(label: "clustering", qos: .userInitiated)
    private let nodeCapacity: Int = 25
    private var workingClusteringWorkItem: DispatchWorkItem?
    
    private lazy var insertWorkItem = DispatchWorkItem { [weak self] in
        self?.coordinates.forEach {
            self?.quadTree.insert(coordinate: $0)
        }
    }
    
    init(coordinates: [Coordinate], boundingBox: BoundingBox) {
        self.coordinates = coordinates
        self.boundingBox = boundingBox
        
        quadTree = QuadTree(boundingBox: boundingBox, nodeCapacity: nodeCapacity)
        // QuadTree boundingbox를 카메라 boundingbox로 했을 때와, minmax를 구해서 했을 때 비교하려고 만듬
        // updateQuadTreeBoundingBox()
        insertCoordinates()
    }
    
    func update(coordinates: [Coordinate]) {
        self.coordinates = coordinates
    }
    
    private func updateQuadTreeBoundingBox() {
        let minMaxCoordinates = coordinatesMinMaxCoordinates()
        quadTree.updateBoundingBox(topRight: minMaxCoordinates.topRight,
                                   bottomLeft: minMaxCoordinates.bottomLeft)
    }
    
    private func clusteringWorkItem(successHandler: @escaping ([Cluster]) -> Void) -> DispatchWorkItem {
        DispatchWorkItem { [weak self] in
            let clusters = self?.clustering()
            successHandler(clusters ?? [])
        }
    }
    
    private func coordinatesMinMaxCoordinates() -> (topRight: Coordinate, bottomLeft: Coordinate) {
        var maxX: Double = boundingBox.bottomLeft.x
        var minX: Double = boundingBox.topRight.x
        var maxY: Double = boundingBox.bottomLeft.y
        var minY: Double = boundingBox.topRight.y
        
        coordinates.forEach { coordinate in
            maxX = max(coordinate.x, maxX)
            minX = min(coordinate.x, minX)
            maxY = max(coordinate.y, maxY)
            minY = min(coordinate.y, minY)
        }
        return (topRight: Coordinate(x: maxX, y: maxY), bottomLeft: Coordinate(x: minX, y: minY))
    }
    
    private func insertCoordinates() {
        queue.async(execute: insertWorkItem)
    }
    
    // 추후 workItem 클러스터링 한개 별로 병렬로 넣는것 vs 한번에 처리하는 것 성능 비교
    private func clustering() -> [Cluster] {
        var result = [Cluster]()
        
        let mockupCount: Double = 4
        let clusterRegionWidth: Double = (boundingBox.topRight.x - boundingBox.bottomLeft.x) / mockupCount
        let clusterRegionHeight: Double = (boundingBox.topRight.y - boundingBox.bottomLeft.y) / mockupCount
        
        var x = boundingBox.bottomLeft.x
        var y = boundingBox.bottomLeft.y
        
        while x < boundingBox.topRight.x {
            while y < boundingBox.topRight.y {
                let topRight = Coordinate(x: x + clusterRegionWidth, y: y + clusterRegionHeight)
                let bottomLeft = Coordinate(x: x, y: y)
                let region = BoundingBox(topRight: topRight, bottomLeft: bottomLeft)
                
                let foundCoordinates = quadTree.findCoordinates(region: region)
                result.append(Cluster(coordinates: foundCoordinates))
                y += clusterRegionHeight
            }
            x += clusterRegionWidth
            y = boundingBox.bottomLeft.y
        }
        return result
    }

}

extension QuadTreeClusteringService: ClusteringServicing {
    
    func execute(
        successHandler: @escaping (([Cluster]) -> Void),
        failureHandler: ((NSError) -> Void)?) {
        queue.async { [weak self] in
            self?.workingClusteringWorkItem = self?.clusteringWorkItem(successHandler: successHandler)
            self?.workingClusteringWorkItem?.perform()
        }
    }
    
    func cancel() {
        insertWorkItem.cancel()
        workingClusteringWorkItem?.cancel()
    }
    
}
