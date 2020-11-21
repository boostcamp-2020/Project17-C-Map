//
//  CoreDataStackTests.swift
//  InteractiveClusteringMapTests
//
//  Created by Oh Donggeon on 2020/11/21.
//

import XCTest

class CoreDataStackTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testFetchPOIEntity() throws {
        let actual = CoreDataStack.shared.fetch()
        XCTAssertNotEqual(actual, [])
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
