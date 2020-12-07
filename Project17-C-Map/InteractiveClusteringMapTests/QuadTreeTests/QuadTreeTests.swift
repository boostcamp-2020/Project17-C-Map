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
        let newQuadTree = Mockup().mockupQuadTree()
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
    
    func test_QuadTree_remove_x_1_y_1() {
        quadTree?.remove(coordinate: coordinates[0])
        let foundCoordinates = quadTree?.findCoordinates(region: boundingBox)
        
        let expectedCoornates = [
            Coordinate(x: 2, y: 2),
            Coordinate(x: 3, y: 3),
            Coordinate(x: 6, y: 6)
        ]
        XCTAssertEqual(foundCoordinates, expectedCoornates)
    }
    
    func test_QuadTree_remove_x_2_y_2() {
        quadTree?.remove(coordinate: coordinates[1])
        let foundCoordinates = quadTree?.findCoordinates(region: boundingBox)
        
        let expectedCoornates = [
            Coordinate(x: 1, y: 1),
            Coordinate(x: 3, y: 3),
            Coordinate(x: 6, y: 6)
        ]
        XCTAssertEqual(foundCoordinates, expectedCoornates)
    }
    
    func test_QuadTree_remove_x_3_y_3() {
        quadTree?.remove(coordinate: coordinates[2])
        let foundCoordinates = quadTree?.findCoordinates(region: boundingBox)
        
        let expectedCoornates = [
            Coordinate(x: 1, y: 1),
            Coordinate(x: 2, y: 2),
            Coordinate(x: 6, y: 6)
        ]
        XCTAssertEqual(foundCoordinates, expectedCoornates)
    }
    
    func test_QuadTree_remove_x_6_y_6() {
        quadTree?.remove(coordinate: coordinates[3])
        let foundCoordinates = quadTree?.findCoordinates(region: boundingBox)
        
        let expectedCoornates = [
            Coordinate(x: 1, y: 1),
            Coordinate(x: 2, y: 2),
            Coordinate(x: 3, y: 3)
        ]
        XCTAssertEqual(foundCoordinates, expectedCoornates)
    }
    
    func test_QuadTree_remove_not_contains() {
        quadTree?.remove(coordinate: Coordinate(x: 4, y: 4))
        let foundCoordinates = quadTree?.findCoordinates(region: boundingBox)
        
        let expectedCoornates = [
            Coordinate(x: 1, y: 1),
            Coordinate(x: 2, y: 2),
            Coordinate(x: 3, y: 3),
            Coordinate(x: 6, y: 6)
        ]
        XCTAssertEqual(foundCoordinates, expectedCoornates)
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

}
