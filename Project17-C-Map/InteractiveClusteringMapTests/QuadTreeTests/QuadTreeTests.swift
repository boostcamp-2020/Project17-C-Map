//
//  QuadTreeTests.swift
//  InteractiveClusteringMapTests
//
//  Created by eunjeong lee on 2020/11/25.
//

import XCTest

class QuadTreeTests: XCTestCase {

    private var quadTree: QuadTree?
    private let topRight = Coordinate(x: 10, y: 10)
    private let bottomLeft = Coordinate(x: 0, y: 0)
    private lazy var boundingBox = BoundingBox(topRight: topRight, bottomLeft: bottomLeft)
    private let nodeCapacity: Int = 1
    private let coordinates = [
        Coordinate(x: 1, y: 1),
        Coordinate(x: 2, y: 2),
        Coordinate(x: 3, y: 3),
        Coordinate(x: 6, y: 6)
        ]
    
    override func setUpWithError() throws {
        quadTree = QuadTree(boundingBox: boundingBox, nodeCapacity: nodeCapacity)
        coordinates.forEach {
            quadTree?.insert(coordinate: $0)
        }
    }
    
    func test_QuadTree_init() {
        XCTAssertNotNil(quadTree)
    }
    
    func test_QuadTree_insert() {
        let newQuadTree = mockupQuadTree()
        XCTAssertEqual(quadTree, newQuadTree)
    }
    
    func test_QuadTree_cannot_insert_coordinates_outside_boundingbox() {
        let newCoordinate = Coordinate(x: 11, y: 11)
        testQuadTreeExcludeNotContains(coordinate: newCoordinate)
    
        let newCoordinate2 = Coordinate(x: -1, y: -1)
        testQuadTreeExcludeNotContains(coordinate: newCoordinate2)
    }
    
    func test_QuadTree_total_tree_coordinates() {
        testQuadTreeFindCoordinates(region: boundingBox, expectedCoordinates: coordinates)
    }
    
    func test_QuadTree_findCoordinates_at_region_2_2_to_4_4() {
        let region = BoundingBox(topRight: Coordinate(x: 4, y: 4),
                                 bottomLeft: Coordinate(x: 2, y: 2))
        let expectedCoordinates = [
            Coordinate(x: 2, y: 2),
            Coordinate(x: 3, y: 3)
        ]
        testQuadTreeFindCoordinates(region: region, expectedCoordinates: expectedCoordinates)
    }
    
    func test_QuadTree_findCoordinates_at_region_2_2_to_6_6() {
        let region = BoundingBox(topRight: Coordinate(x: 6, y: 6),
                                 bottomLeft: Coordinate(x: 2, y: 2))
        let expectedCoordinates = [
            Coordinate(x: 2, y: 2),
            Coordinate(x: 3, y: 3),
            Coordinate(x: 6, y: 6)
        ]
        testQuadTreeFindCoordinates(region: region, expectedCoordinates: expectedCoordinates)
    }
    
    private func testQuadTreeFindCoordinates(region: BoundingBox, expectedCoordinates: [Coordinate]) {
        let findCoordinates = quadTree?.findCoordinates(
            region: region)
        
        XCTAssertEqual(findCoordinates?.count, expectedCoordinates.count)
        findCoordinates?.forEach {
            XCTAssertTrue(expectedCoordinates.contains($0))
        }
    }
    
    private func testQuadTreeExcludeNotContains(coordinate: Coordinate) {
        quadTree?.insert(coordinate: coordinate)
        let foundCoordinates = quadTree?.findCoordinates(region: boundingBox)
        XCTAssertEqual(foundCoordinates?.count, coordinates.count)
        XCTAssertFalse(foundCoordinates?.contains(coordinate) ?? true)
    }
    
    /*
                 5.(1,1)
        /    |         \           \
     1.()    2.(6,6)     3.(2,2)      4.()
                      /   |     \   \
                3-1.() 3-2.(3,3) 3-3.() 3-4.()
     */
    private func mockupQuadTree() -> QuadTree {
        let subtreeBoundingBox = boundingBox.splittedQuadBoundingBoxes()
        
        // 1.
        let topLeft = QuadTree(boundingBox: subtreeBoundingBox[0], nodeCapacity: nodeCapacity)
        
        // 2.
        let topRight = QuadTree(boundingBox: subtreeBoundingBox[1], nodeCapacity: nodeCapacity)
        topRight.insert(coordinate: Coordinate(x: 6, y: 6))

        let bottomLeftSubtreeBoundingBox = subtreeBoundingBox[2].splittedQuadBoundingBoxes()
        // 3-1.
        let bottomLeftTopLeft = QuadTree(boundingBox: bottomLeftSubtreeBoundingBox[0], nodeCapacity: nodeCapacity)
        // 3-2.
        let bottomLeftTopRight = QuadTree(boundingBox: bottomLeftSubtreeBoundingBox[1], nodeCapacity: nodeCapacity)
        bottomLeftTopRight.insert(coordinate: Coordinate(x: 3, y: 3))
        // 3-3.
        let bottomLeftBottomLeft = QuadTree(boundingBox: bottomLeftSubtreeBoundingBox[2], nodeCapacity: nodeCapacity)
        // 3-4.
        let bottomLeftBottomRight = QuadTree(boundingBox: bottomLeftSubtreeBoundingBox[3], nodeCapacity: nodeCapacity)

        // 3.
        let bottomLeft = QuadTree(boundingBox: subtreeBoundingBox[2], nodeCapacity: nodeCapacity, topLeft: bottomLeftTopLeft, topRight: bottomLeftTopRight, bottomLeft: bottomLeftBottomLeft, bottomRight: bottomLeftBottomRight)
        bottomLeft.insert(coordinate: Coordinate(x: 2, y: 2))
        
        // 4.
        let bottomRight = QuadTree(boundingBox: subtreeBoundingBox[3], nodeCapacity: nodeCapacity)

        // 5.
        let newQuadTree = QuadTree(boundingBox: boundingBox, nodeCapacity: nodeCapacity, topLeft: topLeft, topRight: topRight, bottomLeft: bottomLeft, bottomRight: bottomRight)
        newQuadTree.insert(coordinate: Coordinate(x: 1, y: 1))
        
        return newQuadTree
    }

}
