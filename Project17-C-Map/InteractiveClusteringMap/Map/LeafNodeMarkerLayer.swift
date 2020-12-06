//
//  LeafNodeMarkerLayer.swift
//  InteractiveClusteringMap
//
//  Created by A on 2020/12/06.
//

import Foundation
import UIKit

class LeafNodeMarkerLayer: CALayer {
    
    private let marker: LeafNodeMarker
    let editLayer: CALayer
    
    init(marker: LeafNodeMarker) {
        self.marker = marker
        self.editLayer = CALayer()
        super.init()
        configure()
    }
    
    required init?(coder: NSCoder) {
        self.marker = LeafNodeMarker(coordinate: Coordinate(x: 0, y: 0))
        self.editLayer = CALayer()
        super.init()
        configure()
    }
    
    private func configure() {
        bounds = CGRect(x: 0, y: 0, width: marker.iconImage.imageWidth, height: marker.iconImage.imageHeight)
        contents = marker.iconImage.image.cgImage
        contentsGravity = CALayerContentsGravity.resize
        anchorPoint = CGPoint(x: 0.5, y: 1)
        
        let editImage = UIImage(systemName: "minus.circle.fill")?.cgImage
        editLayer.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        editLayer.contents = editImage
       // editLayer.contentsGravity = CALayerContentsGravity.resize
        addSublayer(editLayer)
    }
    
}
