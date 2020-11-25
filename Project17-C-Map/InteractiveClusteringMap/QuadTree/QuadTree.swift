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
    
    private var minX: Double = KoreaCoordinate.maxX
    private var maxX: Double = KoreaCoordinate.minX
    private var minY: Double = KoreaCoordinate.maxY
    private var maxY: Double = KoreaCoordinate.minY
    
    init(boundingBox box: BoundingBox, nodeCapacity: Int) {
        self.boundingBox = box
        self.nodeCapacity = nodeCapacity
    }
    
    init(boundingBox box: BoundingBox,
         nodeCapacity: Int,
         topLeft: QuadTree,
         topRight: QuadTree,
         bottomLeft: QuadTree,
         bottomRight: QuadTree
    ) {
        self.boundingBox = box
        self.nodeCapacity = nodeCapacity
        self.topLeft = topLeft
        self.topRight = topRight
        self.bottomLeft = bottomLeft
        self.bottomRight = bottomRight
    }
    
    @discardableResult
    func insert(coordinate: Coordinate) -> Bool {
        guard boundingBox.contains(coordinate: coordinate) else { return false }
        
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
        maxX = max(coordinate.x, maxX)
        minX = min(coordinate.x, minX)
        maxY = max(coordinate.y, maxY)
        minY = min(coordinate.y, minY)
    }

    private func createSubTree() {
        let boxes = boundingBox.splittedQuadBoundingBoxes()
        guard let topLeftBoundingBox = boxes[safe: SubTreeIndex.TL],
              let topRightBoundingBox = boxes[safe: SubTreeIndex.TR],
              let bottomLeftBoundingBox = boxes[safe: SubTreeIndex.BL],
              let bottomRightBoundingBox = boxes[safe: SubTreeIndex.BR]
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
        lhs.nodeCapacity == rhs.nodeCapacity
    }

}

private extension QuadTree {
    
    enum SubTreeIndex {
        static let TL: Int = 0
        static let TR: Int = 1
        static let BL: Int = 2
        static let BR: Int = 3
    }
    
    enum KoreaCoordinate {
        static let minX: Double = 124
        static let maxX: Double = 132
        static let minY: Double = 33
        static let maxY: Double = 43
    }
}
