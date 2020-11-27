//
//  KMeansCentroidsTest.swift
//  InteractiveClusteringMapTests
//
//  Created by Seungeon Kim on 2020/11/27.
//

import XCTest

class KMeansCentroidsTest: XCTestCase {

    func test_2split_coordinates_by_screen() throws {
        let centroids = mockCentoidsByScreen(number: 2)
        let expected = [
            Coordinate(x: 128.0000, y: 35.5000),
            Coordinate(x: 128.0000, y: 40.5000)
        ]
        
        validateCendroids(centroids: centroids, expected: expected)
    }
    
    func test_4split_coordinates_by_screen() throws {
        let centroids = mockCentoidsByScreen(number: 4)
        let expected = [
            Coordinate(x: 130.0000, y: 38.0000),
            Coordinate(x: 128.0000, y: 35.5000),
            Coordinate(x: 126.0000, y: 38.0000),
            Coordinate(x: 128.0000, y: 40.5000)
        ]
        
        validateCendroids(centroids: centroids, expected: expected)
    }
    
    func test_6split_coordinates_by_screen() throws {
        let centroids = mockCentoidsByScreen(number: 6)
        let expected = [
            Coordinate(x: 130.0000, y: 39.1547),
            Coordinate(x: 130.0000, y: 36.8452),
            Coordinate(x: 128.0000, y: 35.5000),
            Coordinate(x: 126.0000, y: 36.8452),
            Coordinate(x: 126.0000, y: 39.1547),
            Coordinate(x: 128.0000, y: 40.5000)
        ]
        
        validateCendroids(centroids: centroids, expected: expected)
    }
    
    func test_7split_coordinates_by_screen() throws {
        let centroids = mockCentoidsByScreen(number: 7)
        let expected = [
            Coordinate(x: 130.0000, y: 39.5949),
            Coordinate(x: 130.0000, y: 37.5435),
            Coordinate(x: 129.2039, y: 35.5000),
            Coordinate(x: 126.7960, y: 35.5000),
            Coordinate(x: 126.0000, y: 37.5435),
            Coordinate(x: 126.0000, y: 39.5949),
            Coordinate(x: 128.0000, y: 40.5000)
        ]
        
        validateCendroids(centroids: centroids, expected: expected)
    }
    
    func test_coordinates_by_random() throws {
        let cendroids = mockCentoidsByRandom(number: 1000)
        
        cendroids.forEach { cendroid in
            validateCendtoid(cendroid: cendroid)
        }
    }
    
    private func validateCendroids(centroids: [Coordinate], expected: [Coordinate]) {
        XCTAssertEqual(centroids.count, expected.count)
        
        let count = centroids.count
        for i in 0..<count {
            XCTAssertEqual(centroids[i].x, expected[i].x, accuracy: 0.0001)
            XCTAssertEqual(centroids[i].y, expected[i].y, accuracy: 0.0001)
        }
    }
    
    private func validateCendtoid(cendroid: Coordinate) {
        XCTAssert((33.0...43.0).contains(cendroid.y))
        XCTAssert((123.0...132.0).contains(cendroid.x))
    }
    
    private func mockCentoidsByScreen(number: Int) -> [Coordinate] {
        let kmm = KMeans(k: number)
        let topLeft = Coordinate(x: 124.0, y: 43.0)
        let bottomRight = Coordinate(x: 132.0, y: 33.0)
        return kmm.screenCentroids(topLeft: topLeft, bottomRight: bottomRight)
    }
    
    private func mockCentoidsByRandom(number: Int) -> [Coordinate] {
        let kmm = KMeans(k: number)
        
        return kmm.randomCentroids(rangeOfLat: 33.0...43.0, rangeOfLng: 123.0...132.0)
    }

}
