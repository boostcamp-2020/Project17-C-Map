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
    
    private lazy var minX: Double = boundingBox.topRight.x
    private lazy var maxX: Double = boundingBox.bottomLeft.x
    private lazy var minY: Double = boundingBox.topRight.y
    private lazy var maxY: Double = boundingBox.bottomLeft.y
    
    init(boundingBox: BoundingBox, nodeCapacity: Int) {
        self.boundingBox = boundingBox
        self.nodeCapacity = nodeCapacity
    }
    
    convenience init(nodeCapacity: Int) {
        self.init(boundingBox: BoundingBox(topRight: Coordinate(x: 0, y: 0),
                                           bottomLeft: Coordinate(x: 0, y: 0)),
                  nodeCapacity: nodeCapacity)
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
        
        if let bottomLeft = bottomLeft, bottomLeft.insert(coordinate: coordinate) {
            return true
        }
        if let bottomRight = bottomRight, bottomRight.insert(coordinate: coordinate) {
            return true
        }
        if let topLeft = topLeft, topLeft.insert(coordinate: coordinate) {
            return true
        }
        if let topRight = topRight, topRight.insert(coordinate: coordinate) {
            return true
        }
        return false
    }
    
    // 모든 Coordinate가 insert 되면 외부에서 한번 호출 -> 자식까지 모두 BoundingBox 조절
    func updateBoundingBox(topRight: Coordinate? = nil, bottomLeft: Coordinate? = nil) {
        let topRightCoordinate = topRight ?? Coordinate(x: maxX, y: maxY)
        let bottomLeftCoordinate = bottomLeft ?? Coordinate(x: minX, y: minY)
        
        boundingBox = BoundingBox(
            topRight: topRightCoordinate,
            bottomLeft: bottomLeftCoordinate
        )
        
        self.bottomLeft?.updateBoundingBox()
        self.bottomRight?.updateBoundingBox()
        self.topLeft?.updateBoundingBox()
        self.topRight?.updateBoundingBox()
    }
    
    func findCoordinates(region: BoundingBox) -> [Coordinate] {
        
        // MapUtil에서는 카메라 boundary로 region을 계산하고
        // QuadTree내부 boundary는 min, max값으로 업데이트 하니까 여기서 제외되는 값이 있다.
        guard boundingBox.isOverlapped(with: region) else { return [] }
        
        var coordinateInRegion = coordinates.filter { region.contains(coordinate: $0) }
        
        coordinateInRegion += bottomLeft?.findCoordinates(region: region) ?? []
        coordinateInRegion += bottomRight?.findCoordinates(region: region) ?? []
        coordinateInRegion += topLeft?.findCoordinates(region: region) ?? []
        coordinateInRegion += topRight?.findCoordinates(region: region) ?? []
        
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
        guard let bottomLeftBoundingBox = boxes[safe: SubTreeIndex.BL],
              let bottomRightBoundingBox = boxes[safe: SubTreeIndex.BR],
              let topLeftBoundingBox = boxes[safe: SubTreeIndex.TL],
              let topRightBoundingBox = boxes[safe: SubTreeIndex.TR]
        else {
            return
        }
        
        bottomLeft = QuadTree(boundingBox: bottomLeftBoundingBox,
                              nodeCapacity: nodeCapacity)
        bottomRight = QuadTree(boundingBox: bottomRightBoundingBox,
                               nodeCapacity: nodeCapacity)
        topLeft = QuadTree(boundingBox: topLeftBoundingBox,
                           nodeCapacity: nodeCapacity)
        topRight = QuadTree(boundingBox: topRightBoundingBox,
                            nodeCapacity: nodeCapacity)
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
        static let BL: Int = 0
        static let BR: Int = 1
        static let TL: Int = 2
        static let TR: Int = 3
    }
    
}
