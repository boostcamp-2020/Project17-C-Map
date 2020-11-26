//
//  MockPOIService.swift
//  InteractiveClusteringMapTests
//
//  Created by Oh Donggeon on 2020/11/26.
//

import Foundation

class MockPOIService: POIServicing {
    
    let kmeans = KMeansClustering(k: 10)
    var coord: [Coordinate] = []
    
    func fetch(completion: @escaping ([POI]) -> Void) {
        
        let manager = POIService(dataManager: CoreDataStack.shared)
        manager.fetch { pois in
            pois.forEach { poi in
                self.coord.append(Coordinate(x: poi.x, y: poi.y))
            }
        }
        
        let clusters = kmeans.trainCenters(coord, centroids: Array(coord[0..<10]))
        var pois: [POI] = []
        print("arrays: \(Array(coord[0..<5]))")
        clusters.forEach {
            print($0.center)
            print("count: \($0.coordinates.count)")
            pois.append(POI(x: $0.center.x, y: $0.center.y, id: 0, name: "", imageUrl: "", category: ""))
        }
        completion(pois)
    }
    
    func save() {
        
    }
    
}
