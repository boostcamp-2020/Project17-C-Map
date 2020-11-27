//
//  KDefineTests.swift
//  InteractiveClusteringMapTests
//
//  Created by A on 2020/11/25.
//

import XCTest

class KDefineTests: XCTestCase {
    
    let accuracy = 0.001
    private var avc: AverageSilhouetteCalculator?
    
    /// cluster1: A(1,1), B(2,2)
    /// cluster2: C(-2,1), D(-3,-2), D(0, -2)
    private let cluster1 = Cluster(coordinates: [Coordinate(x: 1, y: 1), Coordinate(x: 2, y: 2)])
    private var cluster2 = Cluster(coordinates: [Coordinate(x: -2, y: 1), Coordinate(x: -3, y: -2), Coordinate(x: 0, y: -2)])
    
    override func setUpWithError() throws {
        let clusters = [cluster1, cluster2]
        avc = AverageSilhouetteCalculator(clusters: clusters)
    }
    
    func test_avc_init() throws {
        XCTAssertNotNil(avc)
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
    
    func test_calculate_cohesion() throws {
        guard let result = avc?.calculateCohesion(in: cluster1, target: cluster1.coordinates[0]) else {
            return
        }
        let expected = sqrt(2)
        XCTAssertEqual(expected, result, accuracy: accuracy)
    }
    
    func test_calculate_separation() throws {
        guard let result = avc?.calculateSeparation(in: cluster1, target: cluster1.coordinates[0]) else {
            return
        }
        
        let expected = 3.720759
        XCTAssertEqual(expected, result, accuracy: accuracy)
    }
    
    func test_calculate_silhouette_A() throws {
        guard let result = avc?.calculateSilhouette(with: cluster1, target: cluster1.coordinates[0]) else {
            return
        }
        
        let expected = 0.619912
        XCTAssertEqual(expected, result, accuracy: accuracy)
    }
    
    func test_calculate_silhouette_B() throws {
        guard let result = avc?.calculateSilhouette(with: cluster1, target: cluster1.coordinates[1]) else {
            return
        }
        
        let expected = 0.717126
        XCTAssertEqual(expected, result, accuracy: accuracy)
    }
    
    func test_calculate_average_silhouette_cluster1() throws {
        guard let result = avc?.calculateAverageSilhouette(cluster: cluster1) else {
            return
        }
        
        let expected = 0.668519
        XCTAssertEqual(expected, result, accuracy: accuracy)
    }
    
}
