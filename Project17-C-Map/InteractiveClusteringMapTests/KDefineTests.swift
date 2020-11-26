//
//  KDefineTests.swift
//  InteractiveClusteringMapTests
//
//  Created by A on 2020/11/25.
//

import XCTest

class KDefineTests: XCTestCase {
    
    let accuracy = 0.001
    
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
    
    func test_find_find_cohesion() throws {
        let cluster1 = Cluster(coordinates: [Coordinate(x: 1, y: 1), Coordinate(x: 2, y: 2)])
        let cluster2 = Cluster(coordinates: [Coordinate(x: -2, y: 1), Coordinate(x: -3, y: -2), Coordinate(x: 0, y: -2)])
        let clusters = [cluster1, cluster2]
        let avc = AverageSilhouetteCalculator(clusters: clusters)
        let result = avc.findCohesion(in: cluster1, target: cluster1.coordinates[0])
        let expected = sqrt(2)
        XCTAssertEqual(expected, result, accuracy: accuracy)
    }
    
}
