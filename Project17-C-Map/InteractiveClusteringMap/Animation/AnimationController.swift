//
//  AnimationController.swift
//  InteractiveClusteringMap
//
//  Created by 박성민 on 2020/12/02.
//

import Foundation
import UIKit
import NMapsMap

enum FadeOption {
    case fadeIn, fadeOut
}

final class AnimationController {

    /// Fade In/Out animation
    /// - Parameter inOut: true: fade in, false: fade out
    static func fadeInOut(option: FadeOption) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "opacity")
        if option == .fadeIn {
            animation.fromValue = 0
            animation.toValue = 1
            animation.duration = 0.7
        } else {
            animation.fromValue = 1
            animation.toValue = 0
            animation.duration = 0.6
        }
        
        return animation
    }
    
}
