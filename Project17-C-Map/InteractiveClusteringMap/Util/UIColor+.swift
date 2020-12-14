//
//  UIColor+.swift
//  InteractiveClusteringMap
//
//  Created by Oh Donggeon on 2020/12/13.
//

import UIKit

extension UIColor {
    
    static let greenCyan = UIColor(hex: 0xA0DBCA)
    static let deepBlue = UIColor(hex: 0x3A7FCD)
    
    convenience init(hex: Int, alpha: Float = 1.0) {
        self.init(red: CGFloat((hex >> 16) & 0xFF) / 255.0,
                  green: CGFloat((hex >> 8) & 0xFF) / 255.0,
                  blue: CGFloat(hex & 0xFF) / 255.0,
                  alpha: CGFloat(alpha))
    }
    
}
