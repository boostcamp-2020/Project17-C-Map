//
//  ClusteringManager.swift
//  InteractiveClusteringMap
//
//  Created by eunjeong lee on 2020/11/28.
//

import Foundation

protocol ClusteringServicing {

    func execute(coordinates: [Coordinate]?,
                 boundingBox: BoundingBox,
                 zoomLevel: Double,
                 completionHandler: @escaping (([Cluster]) -> Void))
    
    func cancel()
    
}
