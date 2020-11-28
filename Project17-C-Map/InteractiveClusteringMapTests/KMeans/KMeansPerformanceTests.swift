//
//  KMeansPerformanceTests.swift
//  InteractiveClusteringMapTests
//
//  Created by Seungeon Kim on 2020/11/27.
//

import XCTest

fileprivate struct Mock {
    static let minX = 126.9903617
    static let maxX = 126.9956437
    static let minY = 37.5600365
    static let maxY = 37.5764792
}

class KMeansPerformanceTests: XCTestCase {
    let group = DispatchGroup()
    lazy var coords: [Coordinate] = { () -> [Coordinate] in
        var points: [Coordinate] = []
        for _ in 0..<10000 {
            points.append(generatePoint())
        }
        return points
    }()
    
    func test_performance_measure_kmeans() throws {
        measure {
            kmeansByScreen(k: 22, coords: coords)
        }
    }
    
    func test_performance_measure_kmeans_by_random() throws {
        measure {
            kmeansByRandom(k: 22, coords: coords)
        }
    }
    
    private func asyncNotify(coords: [Coordinate], compltion handler: @escaping ([Coordinate]) -> Void) {
        group.notify(queue: DispatchQueue.main) {
            handler(coords)
        }
    }
    
    private func generatePoint() -> Coordinate {
        let lat = Double.random(in: 37.5600365...37.5764792)
        let lng = Double.random(in: 126.9903617...126.9956437)
        
        return Coordinate(x: lng, y: lat)
    }
    
    @discardableResult
    private func kmeansByScreen(k: Int, coords: [Coordinate]) -> [Cluster] {
        let kmm = KMeans(k: 22)
        
        let topLeft = Coordinate(x: Mock.minX, y: Mock.maxY)
        let bottomRight = Coordinate(x: Mock.maxX, y: Mock.minY)
        let centroids = kmm.screenCentroids(topLeft: topLeft, bottomRight: bottomRight)
        var clusters: [Cluster] = []
        
        clusters = kmm.trainCenters(coords, initialCentroids: centroids)
        
        return clusters
    }
    
    @discardableResult
    private func kmeansByRandom(k: Int, coords: [Coordinate]) -> [Cluster] {
        let kmm = KMeans(k: 22)
        let centroids = kmm.randomCentroids(rangeOfLat: Mock.minY...Mock.maxY,
                                            rangeOfLng: Mock.minX...Mock.maxX)
        var clusters: [Cluster] = []
        
        clusters = kmm.trainCenters(coords, initialCentroids: centroids)
        
        return clusters
    }
    
    private func timeout(_ timeout: TimeInterval, completion: (XCTestExpectation) throws -> Void) rethrows {
        let exp = expectation(description: "Timeout: \(timeout) seconds")
        
        try completion(exp)
        
        waitForExpectations(timeout: timeout) { error in
            guard let error = error else { return }
            XCTFail("Timeout error: \(error)")
        }
    }
}
