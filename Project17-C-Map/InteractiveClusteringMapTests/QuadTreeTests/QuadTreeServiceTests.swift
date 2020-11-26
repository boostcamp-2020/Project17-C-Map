//
//  QuadTreeTests.swift
//  InteractiveClusteringMapTests
//
//  Created by eunjeong lee on 2020/11/25.
//

import XCTest

class QuadTreeServiceTests: XCTestCase {

    private var coordinates = [Coordinate]()
    private let boundingBox = BoundingBox(topRight: Coordinate(x: 100, y: 100),
                                          bottomLeft: Coordinate(x: 0, y: 0))
    private var quadTreeClusteringService: QuadTreeClusteringService?
    
    override func setUpWithError() throws {
        (0...100).forEach { _ in
            let x = Double.random(in: 0...100)
            let y = Double.random(in: 0...100)
            coordinates.append(Coordinate(x: x, y: y))
        }
        quadTreeClusteringService = QuadTreeClusteringService(coordinates: coordinates,
                                                              boundingBox: boundingBox)
    }
    
    func test_QuadTreeClusteringService_init() {
        XCTAssertNotNil(quadTreeClusteringService)
    }
    
    func test_QuadTreeClusteringService_clustering() {
        quadTreeClusteringService?.execute(successHandler: { clusters in
            print("\(clusters.count)")
        }, failureHandler: nil)
    }

}
