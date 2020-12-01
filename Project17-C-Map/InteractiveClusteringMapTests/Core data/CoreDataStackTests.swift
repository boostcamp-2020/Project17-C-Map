//
//  CoreDataStackTests.swift
//  InteractiveClusteringMapTests
//
//  Created by Oh Donggeon on 2020/11/21.
//

import XCTest

class CoreDataStackTests: XCTestCase {
    
    override func setUpWithError() throws {
        
    }

    override func tearDownWithError() throws {
        
    }
    
    func test_fetch_poi_entity() throws {
        let actual = CoreDataStack.shared.fetch()
        XCTAssertEqual(actual, [])
    }

}
