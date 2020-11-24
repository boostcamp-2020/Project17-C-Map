//
//  BoundingBoxTests.swift
//  InteractiveClusteringMapTests
//
//  Created by 박성민 on 2020/11/24.
//

import XCTest
@testable import InteractiveClusteringMap

class BoundingBoxTests: XCTestCase {

    private var boundingBox: BoundingBox?
    
    override func setUpWithError() throws {
        let topRight = Coordinate(x: 100, y: 100)
        let bottomLeft = Coordinate(x: 0, y: 0)

        boundingBox = BoundingBox(topRight: topRight, bottomLeft: bottomLeft)
    }
    
    func test_BoundingBox_init() {
        XCTAssertNotNil(boundingBox)
    }
    
    func test_균일하게_4개로_나누는지_테스트() {
        guard let boundingBoxes = boundingBox?.splitedQuadBoundingBox else { return }
        XCTAssertEqual(boundingBoxes[safe: 0]?.bottomLeft, Coordinate(x: 0, y: 50))
        XCTAssertEqual(boundingBoxes[safe: 0]?.topRight, Coordinate(x: 50, y: 100))
        XCTAssertEqual(boundingBoxes[safe: 1]?.bottomLeft, Coordinate(x: 50, y: 50))
        XCTAssertEqual(boundingBoxes[safe: 1]?.topRight, Coordinate(x: 100, y: 100))
        XCTAssertEqual(boundingBoxes[safe: 2]?.bottomLeft, Coordinate(x: 0, y: 0))
        XCTAssertEqual(boundingBoxes[safe: 2]?.topRight, Coordinate(x: 50, y: 50))
        XCTAssertEqual(boundingBoxes[safe: 3]?.bottomLeft, Coordinate(x: 50, y: 0))
        XCTAssertEqual(boundingBoxes[safe: 3]?.topRight, Coordinate(x: 100, y: 50))
    }
    
    func test_BoundingBox_경계값_Coordinate_넣었을_때_contains_테스트() {
        guard let boundingBox = boundingBox else { return }
        let bottomLeft = Coordinate(x: 0, y: 0)
        let topRight = Coordinate(x: 100, y: 100)
        
        XCTAssertTrue(boundingBox.contains(coordinate: bottomLeft))
        XCTAssertTrue(boundingBox.contains(coordinate: topRight))
    }
    
    func test_BoundingBox_외부값_Coodinate_넣었을_때_contains_테스트() {
        guard let boundingBox = boundingBox else { return }
        let bottomLeft = Coordinate(x: -1, y: -1)
        let topRight = Coordinate(x: 101, y: 101)
        
        XCTAssertFalse(boundingBox.contains(coordinate: bottomLeft))
        XCTAssertFalse(boundingBox.contains(coordinate: topRight))
    }
    
    func test_BoundingBox_겹칠_때_intersectsBoxBounds_테스트() {
        guard let boundingBox = boundingBox else { return }
        let newBox = BoundingBox(topRight: Coordinate(x: 150, y: 150), bottomLeft: Coordinate(x: 100, y: 100))
        let newBox2 = BoundingBox(topRight: Coordinate(x: 1, y: 1), bottomLeft: Coordinate(x: -1, y: -1))
        
        XCTAssertTrue(boundingBox.isOverlapped(with: newBox))
        XCTAssertTrue(boundingBox.isOverlapped(with: newBox2))
    }
    
    func test_BoundingBox_안_겹칠_때_intersectsBoxBounds_테스트() {
        guard let boundingBox = boundingBox else { return }
        let newBox = BoundingBox(topRight: Coordinate(x: 150, y: 150), bottomLeft: Coordinate(x: 101, y: 101))
        let newBox2 = BoundingBox(topRight: Coordinate(x: -1, y: -1), bottomLeft: Coordinate(x: -100, y: -100))

        XCTAssertFalse(boundingBox.isOverlapped(with: newBox))
        XCTAssertFalse(boundingBox.isOverlapped(with: newBox2))
    }
}
