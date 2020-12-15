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
    private var optimalClusters: [Cluster] = []
    private let dbi = DBI()
    
    var generator: CentroidGeneratable

    init(generator: CentroidGeneratable) {
        self.generator = generator
    }
    
    func execute(coordinates: [Coordinate]?,
                 boundingBox: BoundingBox,
                 zoomLevel: Double,
                 completionHandler: @escaping (([Cluster]) -> Void)) {

        guard let coordinates = coordinates else { return }

        validateKMeans(coordinates: coordinates)

        dispatchGroup.notify(queue: serialQueue) { [weak self] in
            guard let self = self else { return }
            self.serialQueue.async {
                completionHandler(self.optimalClusters)
            }
        }

    }

    func cancel() {

    }

    private func validateKMeans(coordinates: [Coordinate]) {
        (10...10).forEach { k in
            self.startKMeans(k: k, coordinates: coordinates)
        }
    }

    private func startKMeans(k: Int, coordinates: [Coordinate]) {
        concurrentQueue.async(group: dispatchGroup) { [weak self] in
            guard let self = self else { return }
            let kmeans = KMeans(k: k, centroidable: self.generator, option: .state)
            kmeans.start(coordinate: coordinates) { result in
                self.compareSilhouette(cluster: result)
            }
        }
    }

    private func compareSilhouette(cluster: [Cluster]) {
//        let cluster = Clusters(items: cluster)

        serialQueue.async {
//            print("optimalCluster :: \(self.optimalClusters.count), DBI :: \(self.dbi.calculateDBI(clusters: self.optimalClusters))")
            print("Cluster :: \(cluster.count), DBI :: \(self.dbi.calculateDBI(clusters: cluster))")
            self.optimalClusters = self.dbi.calculateDBI(clusters: self.optimalClusters) < self.dbi.calculateDBI(clusters: cluster) ? self.optimalClusters : cluster
        }
    }

}

extension KMeansValidateService {
    static let concurrentQueueName = "KMeansValidateService.concurrent"
    static let serialQueueName = "KMeansValidateService.serial"
}
