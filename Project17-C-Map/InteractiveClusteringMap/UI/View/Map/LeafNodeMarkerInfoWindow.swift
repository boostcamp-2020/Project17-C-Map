//
//  LeafNodeMarkerInfoWindow.swift
//  InteractiveClusteringMap
//
//  Created by Seungeon Kim on 2020/12/15.
//

import Foundation
import NMapsMap

class LeafNodeMarkerInfoWindow: NMFInfoWindow {
    
    private let leafNodeMarkerInfoWindowDataSource = LeafNodeMarkerInfoWindowDataSource()

    override init() {
        super.init()
        configureInfoWindow()
    }
    
    private func configureInfoWindow() {
        anchor = CGPoint(x: 0, y: 1)
        dataSource = leafNodeMarkerInfoWindowDataSource
        offsetX = -40
        offsetY = -5
        touchHandler = { [weak self] (_) -> Bool in
            self?.close()
            return true
        }
    }
    
}
