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
            let generator = ScreenCentroidGenerator(topLeft: Coordinate(x: Mock.minX, y: Mock.maxY),
                                                    bottomRight: Coordinate(x: Mock.maxX, y: Mock.minY))
            let kmm = KMeans(k: 22, centroidable: generator, option: .state)
            kmm.start(coordinate: coords) { _ in }
        }
    }
    
    func test_performance_measure_kmeans_by_random() throws {
        measure {
            let generator = RandomCentroidGenerator(rangeOfLat: Mock.minY...Mock.maxY, rangeOfLng: Mock.minX...Mock.maxX)
            let kmm = KMeans(k: 22, centroidable: generator, option: .state)
            kmm.start(coordinate: coords) { _ in }
        }
    }
    
    private func generatePoint() -> Coordinate {
        let lat = Double.random(in: 37.5600365...37.5764792)
        let lng = Double.random(in: 126.9903617...126.9956437)
        
        return Coordinate(x: lng, y: lat)
    }
    
}
