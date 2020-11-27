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
        let cluster1 = Cluster(coordinates: coordinates)
        let cluster2 = Cluster(coordinates: coordinates)
        
        XCTAssertEqual(cluster1, cluster2)
    }
    
    func test_cluster_not_equal() throws {
        let cluster1 = Cluster(coordinates: coordinates)
        coordinates.append(Coordinate(x: 10, y: 20))
        let cluster2 = Cluster(coordinates: coordinates)
        
        XCTAssertNotEqual(cluster1, cluster2)
    }
    
    func test_cluster_equal_hash_value() throws {
        let cluster1 = Cluster(coordinates: coordinates)
        let cluster2 = Cluster(coordinates: coordinates)
        
        XCTAssertEqual(cluster1.hashValue, cluster2.hashValue)
    }
    
    func test_cluster_not_equal_hash_value() throws {
        var coordinates = self.coordinates
        let cluster1 = Cluster(coordinates: coordinates)
        coordinates.append(Coordinate(x: 3, y: 17))
        let cluster2 = Cluster(coordinates: coordinates)
        
        XCTAssertNotEqual(cluster1.hashValue, cluster2.hashValue)
        XCTAssertNotEqual(cluster1, cluster2)
    }
    
    func test_kmeans_clustering() throws {
        let kmeans = KMeans(k: 4)
        let clusters = kmeans.trainCenters(points, initialCentroids: coordinates)
        let expectPoints: [[Coordinate]] = [[Coordinate(x: 1, y: 1), Coordinate(x: 2, y: 2)],
                                                     [Coordinate(x: 8, y: 2), Coordinate(x: 9, y: 1)],
                                                     [Coordinate(x: 9, y: 9), Coordinate(x: 8, y: 8)],
                                                     [Coordinate(x: 2, y: 8), Coordinate(x: 1, y: 9)]]
        var points: [[Coordinate]] = []
        clusters.forEach {
            points.append($0.coordinates)
        }
        
        let expected = expectPoints.contains { expectPoint in
            points.contains { $0 == expectPoint }
        }
        
        XCTAssertTrue(expected)
    }
    
}
