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
    
    func kernalDensityEstimation(datas : [Double], x: Double) -> Double {
        let h = 1.0
        let n = datas.count
        var sum = 0.0
        datas.forEach {
            sum += gaussian(u: (x-$0) / h)
        }
        return 1.0 / Double(n) * h * sum
    }
    
}
