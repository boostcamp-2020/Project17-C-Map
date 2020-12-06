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
        animation.duration = 0.5
        
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
    
    static private func bezierPath(start: CGPoint, end: CGPoint) -> UIBezierPath {
        let bezierPath = UIBezierPath()
        let centerX = Double((start.x + start.y) / 2)
        let centerY = Double((start.y + end.y) / 2)
        let newEnd = CGPoint(x: Double(end.x) - centerX, y: Double(end.y) - centerY)
        var direction: Double = -1
        switch (start.x - end.x, start.y - end.y) {
        case let (x, y) where x > 0 && y >= 0:
            direction = 1
        case let (x, y) where x >= 0 && y < 0:
            direction = 1
        case let (x, y) where x < 0 && y <= 0:
            direction = -1
        default:
            direction = -1
        }
        let sinus = sin(90 * Double.pi * direction / 180)
        let cosinus = cos(90 * Double.pi * direction / 180)
        let rotatedX = cosinus * Double(newEnd.x) - sinus * Double(newEnd.y)
        let rotatedY = sinus * Double(newEnd.x) + cosinus * Double(newEnd.y)
        let controlPoint = CGPoint(x: rotatedX + centerX, y: rotatedY + centerY)
        
        bezierPath.move(to: start)
        bezierPath.addQuadCurve(to: end, controlPoint: controlPoint)
        return bezierPath
    }
    
}
