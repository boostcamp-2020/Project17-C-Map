//
//  AnimationLayerController.swift
//  InteractiveClusteringMap
//
//  Created by 박성민 on 2020/12/02.
//

import Foundation
import UIKit
import NMapsMap

final class AnimationLayerController {
    
    
    /// Fade In/Out animation
    /// - Parameter inOut: true: fade in, false: fade out
    func fadeInOut(inOut: Bool) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "opacity")
        if inOut == true {
            animation.fromValue = 0
            animation.toValue = 1
        } else {
            animation.fromValue = 1
            animation.toValue = 0
        }
        animation.duration = 0.5
        
        return animation
    }
    
}
