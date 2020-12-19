//
//  KMeansTests.swift
//  InteractiveClusteringMapTests
//
//  Created by Oh Donggeon on 2020/11/26.
//

import XCTest

class KMeansTests: XCTestCase {
    
    var points: [Coordinate] = []
    var coordinates: [Coordinate] = []
    
    override func setUpWithError() throws {
        points = [Coordinate(x: 1, y: 1),
                  Coordinate(x: 2, y: 2),
                  Coordinate(x: 8, y: 2),
                  Coordinate(x: 9, y: 1),
                  Coordinate(x: 9, y: 9),
                  Coordinate(x: 8, y: 8),
                  Coordinate(x: 2, y: 8),
                  Coordinate(x: 1, y: 9)]
        
        coordinates = [Coordinate(x: 0, y: 0),
                       Coordinate(x: 10, y: 10),
                       Coordinate(x: 10, y: 0),
                       Coordinate(x: 0, y: 10)]
    }
    
    override func tearDownWithError() throws {
        points = []
        coordinates = []
    }
    
    func test_cluster_equal() throws {
        let cluster1 = Cluster(coordinates: coordinates, boundingBox: .korea)
        let cluster2 = Cluster(coordinates: coordinates, boundingBox: .korea)
        
        XCTAssertEqual(cluster1, cluster2)
    }
    
    func test_cluster_not_equal() throws {
        let cluster1 = Cluster(coordinates: coordinates, boundingBox: .korea)
        coordinates.append(Coordinate(x: 10, y: 20))
        let cluster2 = Cluster(coordinates: coordinates, boundingBox: .korea)
        
        XCTAssertNotEqual(cluster1, cluster2)
    }
    
    func test_cluster_equal_hash_value() throws {
        let cluster1 = Cluster(coordinates: coordinates, boundingBox: .korea)
        let cluster2 = Cluster(coordinates: coordinates, boundingBox: .korea)
        
        XCTAssertEqual(cluster1.hashValue, cluster2.hashValue)
    }
    
    func test_cluster_not_equal_hash_value() throws {
        var coordinates = self.coordinates
        let cluster1 = Cluster(coordinates: coordinates, boundingBox: .korea)
        coordinates.append(Coordinate(x: 3, y: 17))
        let cluster2 = Cluster(coordinates: coordinates, boundingBox: .korea)
        
        XCTAssertNotEqual(cluster1.hashValue, cluster2.hashValue)
        XCTAssertNotEqual(cluster1, cluster2)
    }
    
    func test_kmeans_clustering() throws {
        let centroids = ScreenCentroidGenerator(topLeft: Coordinate(x: 0, y: 10), bottomRight: Coordinate(x: 10, y: 0))
        let kmeans = KMeans(k: 4, centroidable: centroids, option: .state)
        let expectPoints: [[Coordinate]] = [[Coordinate(x: 1, y: 1), Coordinate(x: 2, y: 2)],
                                            [Coordinate(x: 8, y: 2), Coordinate(x: 9, y: 1)],
                                            [Coordinate(x: 9, y: 9), Coordinate(x: 8, y: 8)],
                                            [Coordinate(x: 2, y: 8), Coordinate(x: 1, y: 9)]]
        let expectation: XCTestExpectation = self.expectation(description: "KMeansClustering")
        var actualPoints: [[Coordinate]] = []
        
        kmeans.start(coordinate: self.points) {
            $0.forEach {
                actualPoints.append($0.coordinates)
            }
            
            let expected = expectPoints.contains { expectPoint in
                actualPoints.contains { $0 == expectPoint }
            }
            XCTAssertTrue(expected)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10) { error in
            guard let error = error else { return }
            XCTFail("timeout error: \(error)")
        }
    }
    
}
