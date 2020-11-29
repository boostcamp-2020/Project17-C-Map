//
//  MeanShiftTests.swift
//  InteractiveClusteringMapTests
//
//  Created by Oh Donggeon on 2020/11/29.
//

import XCTest

class MeanShiftTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_gaussian_zero() throws {
        let expected = MeanShift().gaussian(u: 0)
        let actual = 0.39
        
        XCTAssertEqual(expected, actual, accuracy: 0.01)
    }
    
    func test_gaussian_symmetry() throws {
        let expected1 = MeanShift().gaussian(u: 1)
        let expected2 = MeanShift().gaussian(u: -1)
        
        XCTAssertEqual(expected1, expected2, accuracy: 0.001)
    }
    
}
