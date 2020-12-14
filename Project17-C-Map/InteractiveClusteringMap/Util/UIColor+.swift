//
//  UIColor+.swift
//  InteractiveClusteringMap
//
//  Created by Oh Donggeon on 2020/12/13.
//

import UIKit

extension UIColor {
    
    static let greenCyan = UIColor(hex: 0xB4E2C9)
    static let deepBlue = UIColor(hex: 0x64C1CF)
    
    convenience init(hex: Int, alpha: Float = 1.0) {
        self.init(red: CGFloat((hex >> 16) & 0xFF) / 255.0,
                  green: CGFloat((hex >> 8) & 0xFF) / 255.0,
                  blue: CGFloat(hex & 0xFF) / 255.0,
                  alpha: CGFloat(alpha))
    }
    
}
