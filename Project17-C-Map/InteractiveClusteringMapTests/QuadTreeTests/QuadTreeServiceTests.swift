//
//  QuadTreeTests.swift
//  InteractiveClusteringMapTests
//
//  Created by eunjeong lee on 2020/11/25.
//

import XCTest

struct MockupDataStore: TreeDataStorable {
    
    func quadTrees(target: BoundingBox, completion: @escaping ([QuadTree]) -> Void) {
        completion([Mockup().mockupQuadTree()])
    }
    func remove(coordinate: Coordinate) {}
    func add(poi: POI) {}
    func fetch(coordinate: Coordinate) -> POIInfo? {
        return POIInfo(name: nil, imageUrl: nil, category: nil)
    }
 
}

class QuadTreeServiceTests: XCTestCase {
    
    private let coordinates = [
        Coordinate(x: 1, y: 1),
        Coordinate(x: 2, y: 2),
        Coordinate(x: 3, y: 3),
        Coordinate(x: 6, y: 6)
    ]
    private let topRight = Coordinate(x: 10, y: 10)
    private let bottomLeft = Coordinate(x: 0, y: 0)
    private lazy var boundingBox = BoundingBox(topRight: topRight, bottomLeft: bottomLeft)
    private var quadTreeClusteringService: QuadTreeClusteringService?
    
    override func setUpWithError() throws {
        let dataStore = MockupDataStore()
        quadTreeClusteringService = QuadTreeClusteringService(treeDataStore: dataStore)
    }
    
    func test_QuadTreeClusteringService_init() {
        XCTAssertNotNil(quadTreeClusteringService)
    }

    func test_QuadTreeClusteringService_clustering_zoomLevel_5() {
        let expectedClusters = [
            Cluster(coordinates: [
                Coordinate(x: 1, y: 1),
                Coordinate(x: 2, y: 2),
                Coordinate(x: 3, y: 3)
            ], boundingBox: BoundingBox(topRight: Coordinate(x: 5, y: 5), bottomLeft: bottomLeft)),
            Cluster(coordinates: [
                Coordinate(x: 6, y: 6)
            ], boundingBox: BoundingBox(topRight: topRight, bottomLeft: Coordinate(x: 5, y: 5)))
        ]
    
        let expectation: XCTestExpectation = self.expectation(description: "QuadTreeClusteringZoom6")
        
        quadTreeClusteringService?.execute(coordinates: nil, boundingBox: boundingBox, zoomLevel: 5) { clusters in
            XCTAssertEqual(clusters, expectedClusters)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5) { error in
            guard let error = error else { return }
            XCTFail("Timeout error: \(error)")
        }
    }
    
    func test_QuadTreeClusteringService_clustering_zoomLevel_15() {
        let expectedClusters = [
            Cluster(coordinates: [
                Coordinate(x: 1, y: 1)
            ], boundingBox: BoundingBox(topRight: Coordinate(x: 5/3, y: 5/3), bottomLeft: bottomLeft)),
            Cluster(coordinates: [
                Coordinate(x: 2, y: 2),
                Coordinate(x: 3, y: 3)
            ], boundingBox: BoundingBox(topRight: Coordinate(x: (10/3), y: (10/3)), bottomLeft: Coordinate(x: 5/3, y: 5/3))),
            Cluster(coordinates: [
                Coordinate(x: 6, y: 6)
            ], boundingBox: BoundingBox(topRight: Coordinate(x: 5 + (5/3), y: 5 +  (5/3)), bottomLeft: Coordinate(x: 5, y: 5)))
        ]
    
        let expectation: XCTestExpectation = self.expectation(description: "QuadTreeClusteringZoom15")
        
        quadTreeClusteringService?.execute(coordinates: nil, boundingBox: boundingBox, zoomLevel: 15) { clusters in
            XCTAssertEqual(clusters, expectedClusters)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5) { error in
            guard let error = error else { return }
            XCTFail("Timeout error: \(error)")
        }
    }
    
}
