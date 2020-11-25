//
//  QuadTree.swift
//  InteractiveClusteringMap
//
//  Created by 박성민 on 2020/11/23.
//

import Foundation

class QuadTree {
    
    private var coordinates = [Coordinate]()
    
    private var topLeft: QuadTree?
    private var topRight: QuadTree?
    private var bottomLeft: QuadTree?
    private var bottomRight: QuadTree?
    
    private var boundingBox: BoundingBox
    private let nodeCapacity: Int
    
    private var minX: Double = 0.0
    private var maxX: Double = 0.0
    private var minY: Double = 0.0
    private var maxY: Double = 0.0
    
    init(boundingBox box: BoundingBox, nodeCapacity: Int) {
        self.boundingBox = box
        self.nodeCapacity = nodeCapacity
    }
    
    @discardableResult
    func insert(coordinate: Coordinate) -> Bool {
        if boundingBox.contains(coordinate: coordinate) == false {
            return false
        }
        updateMinMax(coordinate: coordinate)
        
        if coordinates.count < nodeCapacity {
            coordinates.append(coordinate)
            return true
        }
        
        if topLeft == nil {
            createSubTree()
        }
        
        if let topLeft = topLeft, topLeft.insert(coordinate: coordinate) {
            return true
        }
        if let topRight = topRight, topRight.insert(coordinate: coordinate) {
            return true
        }
        if let bottomLeft = bottomLeft, bottomLeft.insert(coordinate: coordinate) {
            return true
        }
        if let bottomRight = bottomRight, bottomRight.insert(coordinate: coordinate) {
            return true
        }
        return false
    }
    
    // 모든 Coordinate가 insert 되면 외부에서 한번 호출 -> 자식까지 모두 BoundingBox 조절
    func updateBoundingBox() {
        let topRightCoordinate = Coordinate(x: maxX, y: maxY)
        let bottomLeftCoordinate = Coordinate(x: minX, y: minY)

        boundingBox = BoundingBox(
            topRight: topRightCoordinate,
            bottomLeft: bottomLeftCoordinate
        )
        updateBoundingBoxOfSubTree()
    }
    
    func findCoordinates(region: BoundingBox) -> [Coordinate] {
        
        // MapUtil에서는 카메라 boundary로 region을 계산하고
        // QuadTree내부 boundary는 min, max값으로 업데이트 하니까 여기서 제외되는 값이 있다.
        guard boundingBox.isOverlapped(with: region) else { return [] }
        
        var coordinateInRegion = coordinates.filter { region.contains(coordinate: $0) }

        coordinateInRegion += topLeft?.findCoordinates(region: region) ?? []
        coordinateInRegion += topRight?.findCoordinates(region: region) ?? []
        coordinateInRegion += bottomLeft?.findCoordinates(region: region) ?? []
        coordinateInRegion += bottomRight?.findCoordinates(region: region) ?? []
        
        return coordinateInRegion
    }
    
    private func updateMinMax(coordinate: Coordinate) {
        maxX = coordinate.x > maxX ? coordinate.x : maxX
        minX = coordinate.x < minX ? coordinate.x : minX
        maxY = coordinate.y > maxY ? coordinate.y : maxY
        minY = coordinate.y < minY ? coordinate.y : minY
    }

    private func createSubTree() {
        let boxes = boundingBox.splitedQuadBoundingBox()
        guard let topLeftBoundingBox = boxes[safe: 0],
              let topRightBoundingBox = boxes[safe: 1],
              let bottomLeftBoundingBox = boxes[safe: 2],
              let bottomRightBoundingBox = boxes[safe: 3]
        else {
            return
        }
        
        topLeft = QuadTree(boundingBox: topLeftBoundingBox,
                           nodeCapacity: nodeCapacity)
        topRight = QuadTree(boundingBox: topRightBoundingBox,
                            nodeCapacity: nodeCapacity)
        bottomLeft = QuadTree(boundingBox: bottomLeftBoundingBox,
                              nodeCapacity: nodeCapacity)
        bottomRight = QuadTree(boundingBox: bottomRightBoundingBox,
                               nodeCapacity: nodeCapacity)
    }
    
    private func updateBoundingBoxOfSubTree() {
        guard let topRight = topRight,
              let topLeft = topLeft,
              let bottomRight = bottomRight,
              let bottomLeft = bottomLeft
        else {
            return
        }
        
        topRight.updateBoundingBox()
        topLeft.updateBoundingBox()
        bottomRight.updateBoundingBox()
        bottomLeft.updateBoundingBox()
    }
    
}

extension QuadTree: Equatable {
    
    static func == (lhs: QuadTree, rhs: QuadTree) -> Bool {
        lhs.coordinates == rhs.coordinates &&
        lhs.topLeft == rhs.topLeft &&
        lhs.topRight == rhs.topRight &&
        lhs.bottomLeft == rhs.bottomLeft &&
        lhs.bottomRight == rhs.bottomRight &&
        lhs.boundingBox == rhs.boundingBox &&
        lhs.nodeCapacity == rhs.nodeCapacity &&
        lhs.minX == rhs.minX &&
        lhs.maxX == rhs.maxX &&
        lhs.minY == rhs.minY &&
        lhs.maxY == rhs.maxY
    }

}
