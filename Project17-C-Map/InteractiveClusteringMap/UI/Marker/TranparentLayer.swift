//
//  TranparentLayer.swift
//  InteractiveClusteringMap
//
//  Created by 박성민 on 2020/12/02.
//

import Foundation
import UIKit

class TransparentLayer: CALayer {
    
    init(bounds: CGRect) {
        super.init()
        configure(bounds: bounds)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure(bounds: CGRect) {
        self.bounds = bounds
        self.backgroundColor = UIColor.clear.cgColor
        self.position = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
    }
    
    func removeSublayers() {
        sublayers?.forEach { sublayer in
            sublayer.removeAllAnimations()
            sublayer.removeFromSuperlayer()
        }
    }
    
}
