//
//  LeafNodeMarkerLayer.swift
//  InteractiveClusteringMap
//
//  Created by A on 2020/12/06.
//

import Foundation
import UIKit

class LeafNodeMarkerLayer: CALayer {

    let editButtonLayer: CALayer
    let markerID: Int64
    
    private let systemCircleImageName: String = "minus.circle.fill"
    
    init(markerID: Int64) {
        self.editButtonLayer = CALayer()
        self.markerID = markerID
        super.init()
        configure()
    }
    
    required init?(coder: NSCoder) {
        self.editButtonLayer = CALayer()
        self.markerID = -1
        super.init()
        configure()
    }
    
    func addEditButtonLayer() {
        let editImage = UIImage(systemName: systemCircleImageName)
        
        editImage?.withTintColor(.red)
        editButtonLayer.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        editButtonLayer.contents = editImage?.cgImage
        editButtonLayer.contentsGravity = .resize
        addSublayer(editButtonLayer)
    }
    
    private func configure() {
        contentsGravity = CALayerContentsGravity.resize
        anchorPoint = CGPoint(x: 0.5, y: 1)
    }
    
}
