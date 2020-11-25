//
//  KMeansTests.swift
//  InteractiveClusteringMapTests
//
//  Created by Oh Donggeon on 2020/11/26.
//

import XCTest

class KMeansTests: XCTestCase {
    
    var coordinates: [Coordinate] = [Coordinate(x: 0, y: 2),
                                     Coordinate(x: -4, y: 4),
                                     Coordinate(x: 6, y: -6),
                                     Coordinate(x: 8, y: 20),
                                     Coordinate(x: 13, y: 54)]

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_cluster_equal_hash_value() throws {
        let cluster1 = Cluster(center: Coordinate(x: 0, y: 0), coordinates: coordinates)
        let cluster2 = Cluster(center: Coordinate(x: 3, y: 3), coordinates: coordinates)
        
        XCTAssertEqual(cluster1.hashValue, cluster2.hashValue)
        XCTAssertNotEqual(cluster1, cluster2)
    }

    func test_cluster_not_equal_hash_value() throws {
        let cluster1 = Cluster(center: Coordinate(x: 0, y: 0), coordinates: coordinates)
        coordinates.append(Coordinate(x: 3, y: 17))
        let cluster2 = Cluster(center: Coordinate(x: 0, y: 0), coordinates: coordinates)
        
        XCTAssertNotEqual(cluster1.hashValue, cluster2.hashValue)
        XCTAssertNotEqual(cluster1, cluster2)
    }
    
    func test_cluster_equal() throws {
        let cluster1 = Cluster(center: Coordinate(x: 0, y: 0), coordinates: coordinates)
        let cluster2 = Cluster(center: Coordinate(x: 0, y: 0), coordinates: coordinates)
        
        XCTAssertEqual(cluster1, cluster2)
    }

}
