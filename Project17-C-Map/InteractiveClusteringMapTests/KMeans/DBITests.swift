//
//  DBITests.swift
//  InteractiveClusteringMapTests
//
//  Created by A on 2020/12/02.
//

import XCTest

class DBITests: XCTestCase {
    
    private let dbi = DBI()
    
    func tests_DBI() throws {
        let clusters1 = [Cluster(coordinates: [Coordinate(x: 1, y: 1), Coordinate(x: 5, y: 1)], boundingBox: .korea),
                         Cluster(coordinates: [Coordinate(x: 1, y: 3), Coordinate(x: 5, y: 3)], boundingBox: .korea)]
        let expected = 2.0
        XCTAssertEqual(expected, dbi.calculateDBI(clusters: clusters1))
    }
    
    func tests_DBI_2() throws {
        let clusters2 = [Cluster(coordinates: [Coordinate(x: 1, y: 1), Coordinate(x: 1, y: 3)], boundingBox: .korea),
                         Cluster(coordinates: [Coordinate(x: 5, y: 1), Coordinate(x: 5, y: 3)], boundingBox: .korea)]
        let expected = 0.5
        XCTAssertEqual(expected, dbi.calculateDBI(clusters: clusters2))
    }

}
