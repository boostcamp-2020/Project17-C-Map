//
//  MeanShift.swift
//  InteractiveClusteringMap
//
//  Created by Oh Donggeon on 2020/11/29.
//

import Foundation

struct MeanShift {
    
    func gaussian(u: Double) -> Double {
        return exp(-pow(u, 2) / 2.0) * 1.0 / sqrt(2.0 * .pi)
    }
    
}
