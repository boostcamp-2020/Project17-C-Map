//
//  MockPOIService.swift
//  InteractiveClusteringMapTests
//
//  Created by Oh Donggeon on 2020/11/26.
//

import Foundation

class MockPOIService: POIServicing {
    
    let kmeans = KMeansClustering(k: 3)
    var coord: [Coordinate] = []
    
    func fetch(completion: @escaping ([POI]) -> Void) {
        
        let manager = POIService(dataManager: CoreDataStack.shared)
        manager.fetch { pois in
            pois.forEach { poi in
                self.coord.append(Coordinate(x: poi.x, y: poi.y))
            }
        }
        let clusters = kmeans.trainCenters(coord, initialCentroids: Array(coord[0..<22]))
        var pois: [POI] = []
        
        clusters.forEach {
            pois.append(POI(x: $0.center.x, y: $0.center.y, id: 0, name: "", imageUrl: "", category: ""))
        }
        print(pois.count)
        completion(pois)
    }
    
    func save() {
        
    }
    
}
