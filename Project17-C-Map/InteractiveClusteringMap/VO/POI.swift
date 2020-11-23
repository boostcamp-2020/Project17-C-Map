//
//  POI.swift
//  InteractiveClusteringMap
//
//  Created by Oh Donggeon on 2020/11/21.
//

import Foundation

struct POI: Equatable {
    
    let x: Double
    let y: Double
    let id: Int64?
    let name: String?
    let imageUrl: String?
    let category: String?
    
}

extension POI {
    
    enum Name: String {
        case x, y, id, name, imageUrl, category
    }
    
}
