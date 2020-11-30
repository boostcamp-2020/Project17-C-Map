//
//  KDefineTests.swift
//  InteractiveClusteringMapTests
//
//  Created by A on 2020/11/25.
//

import XCTest

class KDefineTests: XCTestCase {
    
    let accuracy = 0.001
    
    /// cluster1: A(1,1), B(2,2)
    /// cluster2: C(-2,1), D(-3,-2), D(0, -2)
    private let cluster1 = Cluster(coordinates: [Coordinate(x: 1, y: 1), Coordinate(x: 2, y: 2)])
    private var cluster2 = Cluster(coordinates: [Coordinate(x: -2, y: 1), Coordinate(x: -3, y: -2), Coordinate(x: 0, y: -2)])
    
    override func setUpWithError() throws {
        
    }
    
    override func tearDownWithError() throws {
        
    }
    
    func test_rule_of_thumb_with_5000() throws {
        let expected = 50
        let numberOfData = 5000
        XCTAssertEqual(KwithRuleOfThumb(numberOfData: numberOfData), expected)
    }
    
    func test_rule_of_thumb_with_8000() throws {
        let expected = 63
        let numberOfData = 8000
        XCTAssertEqual(KwithRuleOfThumb(numberOfData: numberOfData), expected)
    }
    
    func test_calculate_silhouette() throws {
        let clusters = Clusters(items: [cluster1, cluster2])
        let expected = 0.441
        XCTAssertEqual(expected, clusters.silhouette(), accuracy: accuracy)
    }
    
}
