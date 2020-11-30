//
//  KMeansCentroidsTest.swift
//  InteractiveClusteringMapTests
//
//  Created by Seungeon Kim on 2020/11/27.
//

import XCTest

class KMeansCentroidsTest: XCTestCase {
    
    private let rangeOfLat: ClosedRange = 33.0...43.0
    private let rangeOfLng: ClosedRange = 123.0...132.0

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
        let centroids = mockCentoidsByRandom(number: 1000)
        
        centroids.forEach { cendroid in
            validateCentroids(cendroid: cendroid)
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
    
    private func validateCentroids(cendroid: Coordinate) {
        XCTAssert((33.0...43.0).contains(cendroid.y))
        XCTAssert((123.0...132.0).contains(cendroid.x))
    }
    
    private func mockCentoidsByScreen(number: Int) -> [Coordinate] {
        let topLeft = Coordinate(x: 124.0, y: 43.0)
        let bottomRight = Coordinate(x: 132.0, y: 33.0)
        let centroids = ScreenCentroidGenerator(k: number, topLeft: topLeft, bottomRight: bottomRight)
        return centroids.centroids()
    }
    
    private func mockCentoidsByRandom(number: Int) -> [Coordinate] {
        let centroids = RandomCentroidGenerator(k: number, rangeOfLat: rangeOfLat, rangeOfLng: rangeOfLng)
        return centroids.centroids()
    }

}
