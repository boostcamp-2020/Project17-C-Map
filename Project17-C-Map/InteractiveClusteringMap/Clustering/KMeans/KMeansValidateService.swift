//
//  KMeansValidateService.swift
//  InteractiveClusteringMap
//
//  Created by Seungeon Kim on 2020/11/29.
//

import Foundation

class KMeansValidateService: ClusteringServicing {
    
    private let dispatchGroup = DispatchGroup()
    private let concurrentQueue = DispatchQueue.init(label: concurrentQueueName,
                                                     qos: .userInitiated,
                                                     attributes: .concurrent)
    private let serialQueue = DispatchQueue.init(label: serialQueueName)
    private var bestCluster = Clusters(items: [])
    
    func execute(coordinates: [Coordinate]?,
                 boundingBox: BoundingBox,
                 zoomLevel: Double,
                 completionHandler: @escaping (([Cluster]) -> Void)) {
        
        guard let coordinates = coordinates else { return }
        
        validateKMeans(coordinates: coordinates)
        
        dispatchGroup.notify(queue: serialQueue) { [weak self] in
            guard let self = self else { return }

            completionHandler(self.bestCluster.items)
        }
        
    }
    
    func cancel() {
        
    }
    
    private func validateKMeans(coordinates: [Coordinate]) {
        (2...60).forEach { k in
            self.startKMeans(k: k, coordinates: coordinates)
        }
    }
    
    private func startKMeans(k: Int, coordinates: [Coordinate]) {
        concurrentQueue.async(group: dispatchGroup) {
            let centroidGenerator = BallCutCentroidGenerator(k: k,
                                                             coverage: 0.001,
                                                             coordinates: coordinates)
            let kmeans = KMeans(k: k, centroidable: centroidGenerator, option: .state)
            kmeans.start(coordinate: coordinates) { result in
                self.compareSilhouette(cluster: result)
            }
        }
    }
    
    private func compareSilhouette(cluster: [Cluster]) {
        let cluster = Clusters(items: cluster)
        
        serialQueue.async {
            self.bestCluster = self.bestCluster.silhouette > cluster.silhouette ? self.bestCluster : cluster
        }
    }
    
}

extension KMeansValidateService {
    static let concurrentQueueName = "KMeansValidateService.concurrent"
    static let serialQueueName = "KMeansValidateService.serial"
}
