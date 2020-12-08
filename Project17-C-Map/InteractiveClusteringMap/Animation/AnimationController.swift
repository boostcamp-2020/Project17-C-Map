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

enum ScaleOption {
    case increase, decrease
}

final class AnimationController {
    
    /// Fade In/Out animation
    ///
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
    
    static func transformScale(option: ScaleOption) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        
        if option == .increase {
            animation.fromValue = 0.3
            animation.toValue = 1
        } else {
            animation.fromValue = 1
            animation.toValue = 0.3
        }
        
        animation.duration = 0.5
        animation.timingFunction = CAMediaTimingFunction.init(name: .easeInEaseOut)
        
        return animation
    }
    
    static func movePosition(start: CGPoint, end: CGPoint) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "position")
        animation.fromValue = start
        animation.toValue = end
        animation.duration = 0.2
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        
        return animation
    }
    
    /// bezierPath를 통한 위치변경 애니메이션
    ///
    /// - Parameters:
    ///   - start: start position
    ///   - end: end position
    /// - Returns: CAKeyframeAnimation
    static func movePositionWithPath(start: CGPoint, end: CGPoint) -> CAKeyframeAnimation {
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.path = bezierPath(start: start, end: end).cgPath
        animation.duration = 1
        
        return animation
    }
    
    /// bezierPath 추후 구현
    static private func bezierPath(start: CGPoint, end: CGPoint) -> UIBezierPath {
        let bezierPath = UIBezierPath()
        
        bezierPath.move(to: start)
        return bezierPath
    }
    
    static func shake() -> CAAnimationGroup {
        let shakeAnimation = CAAnimationGroup()
        let shakeValues: [Double] = [-5, 5, -4, 4, -3, 3, -2, 2, -1, 1, 0, 0]
        guard let randomIndex = (0...shakeValues.count).filter({ $0 % 2 == 0 }).randomElement() else {
            return shakeAnimation
        }
        let translation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        let rotation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        
        translation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        translation.values = shakeValues.shifted(by: randomIndex)
        
        rotation.values = shakeValues.map { (Double.pi * $0) / 180 }
        
        shakeAnimation.animations = [translation, rotation]
        shakeAnimation.duration = 2
        
        return shakeAnimation
    }
    
    static func leafNodeAnimation(position: CGPoint) -> CAAnimationGroup {
        let resultAnimation = CAAnimationGroup()
        let moveBig = movePosition(start: position, end: CGPoint(x: position.x, y: position.y - 50))
        moveBig.autoreverses = true
        moveBig.repeatCount = 1
        
        let moveSmall = movePosition(start: position, end: CGPoint(x: position.x, y: position.y - 30))
        moveSmall.autoreverses = true
        moveSmall.beginTime = 0.4
        
        let expandScale = transformScale(option: .increase)
        
        resultAnimation.animations = [moveBig, moveSmall, expandScale]
        resultAnimation.duration = 0.8
        
        return resultAnimation
    }
    
}
