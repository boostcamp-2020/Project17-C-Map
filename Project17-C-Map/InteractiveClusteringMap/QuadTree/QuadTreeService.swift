//
//  QuadTreeClusteringService.swift
//  InteractiveClusteringMap
//
//  Created by eunjeong lee on 2020/11/25.
//

import Foundation

protocol ClusteringServicing {
    
    func execute(successHandler: (([Cluster]) -> Void)?, failureHandler: ((NSError) -> Void)?)
    func cancel()
    
}

class QuadTreeClusteringService {
    
    // 외부에서 카메라 위치 바뀌면 어떻게 할지 생각
    private var coordinates: [Coordinate]
    private let quadTree: QuadTree
    private let boundingBox: BoundingBox
    private let nodeCapacity: Int = 25
    
    init(coordinates: [Coordinate], boundingBox: BoundingBox) {
        self.coordinates = coordinates
        self.boundingBox = boundingBox
        
        quadTree = QuadTree(boundingBox: boundingBox, nodeCapacity: nodeCapacity)
        // QuadTree boundingbox를 카메라 boundingbox로 했을 때와, minmax를 구해서 했을 때 비교하려고 만듬
        // updateQuadTreeBoundingBox()
    }
    
    func update(coordinates: [Coordinate]) {
        self.coordinates = coordinates
    }
    
    private func updateQuadTreeBoundingBox() {
        let minMaxCoordinates = coordinatesMinMaxCoordinates()
        quadTree.updateBoundingBox(topRight: minMaxCoordinates.topRight,
                                   bottomLeft: minMaxCoordinates.bottomLeft)
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
    
}

extension QuadTreeClusteringService: ClusteringServicing {
    
    func execute(successHandler: (([Cluster]) -> Void)?, failureHandler: ((NSError) -> Void)?) {
        
    }
    
    func cancel() {

    }
    
}
