//
//  KDefineTests.swift
//  InteractiveClusteringMapTests
//
//  Created by A on 2020/11/25.
//

import XCTest

    class KDefineTests: XCTestCase {

    func test_RuleOfThumb_with_5000() throws {
        let expected = 50
        let numberOfData = 5000
        XCTAssertEqual(KwithRuleOfThumb(numberOfData: numberOfData), expected)
    }
    
    func test_RuleOfThumb_with_8000() throws {
        let expected = 63
        let numberOfData = 8000
        XCTAssertEqual(KwithRuleOfThumb(numberOfData: numberOfData), expected)
    }

}
