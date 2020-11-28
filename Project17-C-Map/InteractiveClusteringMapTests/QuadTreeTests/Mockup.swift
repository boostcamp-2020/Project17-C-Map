//
//  Mockup.swift
//  InteractiveClusteringMapTests
//
//  Created by 박성민 on 2020/11/28.
//

import Foundation

class Mockup {
    
    private let topRight = Coordinate(x: 10, y: 10)
    private let bottomLeft = Coordinate(x: 0, y: 0)
    private lazy var boundingBox = BoundingBox(topRight: topRight, bottomLeft: bottomLeft)
    private let nodeCapacity: Int = 1
    /*
                 5.(1,1)
        /    |         \           \
     1.()    2.(6,6)     3.(2,2)      4.()
                      /   |     \   \
                3-1.() 3-2.(3,3) 3-3.() 3-4.()
     */
    func mockupQuadTree() -> QuadTree {
        let subtreeBoundingBox = boundingBox.splittedQuadBoundingBoxes()
        
        // 1.
        let topLeft = QuadTree(boundingBox: subtreeBoundingBox[2], nodeCapacity: nodeCapacity)
        
        // 2.6,
        let topRight = QuadTree(boundingBox: subtreeBoundingBox[3], nodeCapacity: nodeCapacity)
        topRight.insert(coordinate: Coordinate(x: 6, y: 6))

        let bottomLeftSubtreeBoundingBox = subtreeBoundingBox[0].splittedQuadBoundingBoxes()
        // 3-1.
        let bottomLeftTopLeft = QuadTree(boundingBox: bottomLeftSubtreeBoundingBox[2], nodeCapacity: nodeCapacity)
        // 3-2.
        let bottomLeftTopRight = QuadTree(boundingBox: bottomLeftSubtreeBoundingBox[3], nodeCapacity: nodeCapacity)
        bottomLeftTopRight.insert(coordinate: Coordinate(x: 3, y: 3))
        // 3-3.
        let bottomLeftBottomLeft = QuadTree(boundingBox: bottomLeftSubtreeBoundingBox[0], nodeCapacity: nodeCapacity)
        // 3-4.
        let bottomLeftBottomRight = QuadTree(boundingBox: bottomLeftSubtreeBoundingBox[1], nodeCapacity: nodeCapacity)

        // 3.
        let bottomLeft = QuadTree(boundingBox: subtreeBoundingBox[0], nodeCapacity: nodeCapacity, topLeft: bottomLeftTopLeft, topRight: bottomLeftTopRight, bottomLeft: bottomLeftBottomLeft, bottomRight: bottomLeftBottomRight)
        bottomLeft.insert(coordinate: Coordinate(x: 2, y: 2))
        
        // 4.
        let bottomRight = QuadTree(boundingBox: subtreeBoundingBox[1], nodeCapacity: nodeCapacity)

        // 5.
        let newQuadTree = QuadTree(boundingBox: boundingBox, nodeCapacity: nodeCapacity, topLeft: topLeft, topRight: topRight, bottomLeft: bottomLeft, bottomRight: bottomRight)
        newQuadTree.insert(coordinate: Coordinate(x: 1, y: 1))
        
        return newQuadTree
    }
}
