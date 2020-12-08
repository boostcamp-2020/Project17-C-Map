//
//  QuadTreeClusteringService.swift
//  InteractiveClusteringMap
//
//  Created by eunjeong lee on 2020/11/25.
//
// 처음 보여줘야할 영역 (한반도 기준 // 데이터 갯수) 33 ~ 43, 124 ~ 132
// 그 영역을 몇개로 분할할 것인가 // 10:8 = 0.5:0.4 // 20 * 20
//

import Foundation

final class QuadTreeClusteringService {
    
    private let treeDataStore: TreeDataStorable
    private var quadTreeWithBoundary: [BoundingBox: QuadTree] = [: ]
    
    init(treeDataStore: TreeDataStorable) {
        self.treeDataStore = treeDataStore
    }
    
    func delete(coordinate: Coordinate) {
        treeDataStore.remove(coordinate: coordinate)
    }
    
    // 클러스터링 Task를 WorkItem으로 반환
    private func clusteringWorkItem(target: BoundingBox,
                                    zoomLevel: Double,
                                    completion: @escaping (([Cluster]) -> Void)) -> DispatchWorkItem {
        DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            self.clustering(target: target, zoomLevel: zoomLevel) { clusters in
                DispatchQueue.main.async {
                    completion(clusters)
                }
            }
        }
    }
    
    //cluster 결과값을 반환한다.
    private func clustering(target: BoundingBox, zoomLevel: Double, completion: @escaping ([Cluster]) -> Void) {
        treeDataStore.quadTrees(target: target) {
            completion(self.excuteClustering(quadTrees: $0, boundingBox: target, zoomLevel: zoomLevel))
        }
    }
    
    // TODO: 추후 workItem 클러스터링 한개 별로 병렬로 넣는것 vs 한번에 처리하는 것 성능 비교
    // 한 클러스터 영역 크기를 정해, 전체 BoundingBox(클러스터 해야되는 범위 전체)를 순서대로 순회하면서 Clustering한다.
    private func excuteClustering(quadTrees: [QuadTree],
                                  boundingBox: BoundingBox,
                                  zoomLevel: Double) -> [Cluster] {
        
        let (widthCount, heightCount) = clusterCount(at: boundingBox, zoomLevel: zoomLevel)
        let clusterRegionWidth: Double = (boundingBox.topRight.x - boundingBox.bottomLeft.x) / Double(widthCount)
        let clusterRegionHeight: Double = (boundingBox.topRight.y - boundingBox.bottomLeft.y) / Double(heightCount)
        
        var (bottomLeftX, bottomLeftY) = (boundingBox.bottomLeft.x, boundingBox.bottomLeft.y)
        var result = [Cluster]()
        
        (0..<heightCount).forEach { _ in
            (0..<widthCount).forEach { _ in
                defer {
                    bottomLeftX += clusterRegionWidth
                }
                let topRight = Coordinate(x: bottomLeftX + clusterRegionWidth, y: bottomLeftY + clusterRegionHeight)
                let bottomLeft = Coordinate(x: bottomLeftX, y: bottomLeftY)
                let region = BoundingBox(topRight: topRight, bottomLeft: bottomLeft)
                
                let foundCoordinates = quadTrees.flatMap {
                    $0.findCoordinates(region: region)
                }
                guard !foundCoordinates.isEmpty else { return }
                result.append(Cluster(coordinates: foundCoordinates, boundingBox: region))
            }
            
            bottomLeftY += clusterRegionHeight
            bottomLeftX = boundingBox.bottomLeft.x
        }
        return result
    }
    
    private func clusterCount(at boundingBox: BoundingBox, zoomLevel: Double) -> (width: Int, height: Int) {
        let widthCount = Int(min((zoomLevel / 2.5), 8))
        let heightCount = Int(Double(widthCount) / boundingBox.topRight.ratio(other: boundingBox.bottomLeft))
        
        return (width: max(1, widthCount), height: max(1, heightCount))
    }
    
}

extension QuadTreeClusteringService: ClusteringServicing {
    
    func execute(coordinates: [Coordinate]?,
                 boundingBox: BoundingBox,
                 zoomLevel: Double,
                 completionHandler: @escaping (([Cluster]) -> Void)) {
        
        let workItem = clusteringWorkItem(target: boundingBox, zoomLevel: zoomLevel, completion: completionHandler)
        DispatchQueue.global().async(execute: workItem)
    }
    
    func cancel() {}
    
}
