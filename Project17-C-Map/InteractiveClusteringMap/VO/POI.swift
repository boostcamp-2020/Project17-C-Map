//
//  POI.swift
//  InteractiveClusteringMap
//
//  Created by Oh Donggeon on 2020/11/21.
//

import Foundation

struct POI: Equatable {
    
    private(set) var x: Double
    private(set) var y: Double
    private(set) var id: Int64?
    private(set) var name: String?
    private(set) var imageUrl: String?
    private(set) var category: String?
    
}
