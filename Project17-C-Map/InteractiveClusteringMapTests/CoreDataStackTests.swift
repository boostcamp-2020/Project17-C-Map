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
    
    func testFetchPOIEntity() throws {
        CoreDataStack.shared.setValue(POI(x: 0, y: 0, id: 0, name: "", imageUrl: "", category: ""))
        CoreDataStack.shared.save { }
        let actual = CoreDataStack.shared.fetch()
        sleep(3)
        XCTAssertNotEqual(actual, [])
    }

}
