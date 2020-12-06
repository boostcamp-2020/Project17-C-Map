//
//  LeafNodeMarkerLayer.swift
//  InteractiveClusteringMap
//
//  Created by A on 2020/12/06.
//

import Foundation
import UIKit

class LeafNodeMarkerLayer: CALayer {
    
    private let markerID: Int64
    
    init(markerID: Int64) {
        self.markerID = markerID
        super.init()
    }
    
    required init?(coder: NSCoder) {
        self.markerID = -1
        super.init()
    }
    
    private func configure() {
        
    }
    
}
