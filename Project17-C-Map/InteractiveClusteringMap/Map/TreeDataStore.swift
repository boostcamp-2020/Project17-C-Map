//
//  TreeDataStore.swift
//  InteractiveClusteringMap
//
//  Created by eunjeong lee on 2020/12/05.
//

import Foundation

protocol TreeDataStorable {
    func quadTrees(target: BoundingBox, completion: @escaping ([QuadTree]) -> Void)
    func remove(coordinate: Coordinate)
    func add(coordinate: Coordinate)
}

class TreeDataStore: TreeDataStorable {
    
    private let concurrentQueue: DispatchQueue = DispatchQueue.init(label: QueueName.concurrent, attributes: .concurrent)
    private let poiService: POIServicing
    private var quadTreeWithBoundary: [BoundingBox: QuadTree] = [: ]
    private let dispatchGroup: DispatchGroup = DispatchGroup()
    
    init(poiService: POIServicing) {
        self.poiService = poiService
        self.makeQuadTrees()
    }
    
    //target에 속한 쿼드트리를 찾아서 반환한다.
    func quadTrees(target: BoundingBox, completion: @escaping ([QuadTree]) -> Void) {
        dispatchGroup.notify(queue: concurrentQueue) {
            let quadTress = self.quadTreeWithBoundary.filter { $0.key.isOverlapped(with: target) }.map {$0.value}
            completion(quadTress)
        }
    }
    
    func remove(coordinate: Coordinate) {
        let trees = quadTreeWithBoundary.filter { $0.key.contains(coordinate: coordinate) }
        trees.forEach {
            $0.value.remove(coordinate: coordinate)
        }
    }
    
    func add(coordinate: Coordinate) {
        let trees = quadTreeWithBoundary.filter { $0.key.contains(coordinate: coordinate) }
        trees.first?.value.insert(coordinate: coordinate)
    }
    
    private func makeQuadTrees() {
        let width = BoundingBox.korea.topRight.x - BoundingBox.korea.bottomLeft.x - 4
        let height = BoundingBox.korea.topRight.y - BoundingBox.korea.bottomLeft.y - 4
        
        for row in 1...Count.split {
            for column in 1...Count.split {
                dispatchGroup.enter()
                concurrentQueue.async {
                    let left = (BoundingBox.korea.bottomLeft.x + 2) + (width / Double(Count.split) * Double(row - 1))
                    let right = (BoundingBox.korea.bottomLeft.x + 2) + (width / Double(Count.split)) * Double(row)
                    let top = (BoundingBox.korea.bottomLeft.y + 2) + (height / Double(Count.split) * Double(column))
                    let bottom = (BoundingBox.korea.bottomLeft.y + 2) + (height / Double(Count.split) * Double(column - 1))
                    
                    let boundingBox = BoundingBox(topRight: Coordinate(x: right, y: top), bottomLeft: Coordinate(x: left, y: bottom))
                    
                    self.makeQuadTree(boundingBox: boundingBox)
                }
            }
        }
    }
    
    // POIServicing으로 부터 해당 영역의 POI 데이터를 불러온다.
    // 해당 영역의 데이터들로 quadTree를 생성한다.
    private func makeQuadTree(boundingBox: BoundingBox) {
        poiService.fetch(bottomLeft: boundingBox.bottomLeft, topRight: boundingBox.topRight) { [weak self] coordinates in
            guard let self = self else { return }
            let tree = QuadTree(boundingBox: boundingBox, nodeCapacity: Capacity.node)
            self.quadTreeWithBoundary[boundingBox] = tree
            self.concurrentQueue.async {
                self.insertCoordinatesAsync(quadTree: tree, coordinates: coordinates)
                self.dispatchGroup.leave()
            }
        }
    }
    
    private func insertCoordinatesAsync(quadTree: QuadTree, coordinates: [Coordinate]) {
        coordinates.forEach {
            quadTree.insert(coordinate: $0)
        }
    }
    
}

private extension TreeDataStore {
    
    enum QueueName {
        static let concurrent = "Clustering.ConcurrentQueue"
    }
    
    enum Capacity {
        static let node: Int = 35
    }
    
    enum Count {
        static let split = 3
    }
    
}
