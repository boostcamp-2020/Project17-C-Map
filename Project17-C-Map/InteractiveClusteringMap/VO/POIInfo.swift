//
//  POIInfo.swift
//  InteractiveClusteringMap
//
//  Created by Oh Donggeon on 2020/12/02.
//

import Foundation

struct POIInfo: Codable {
    
    let name: String?
    let imageUrl: String?
    let category: String?
    
    init(name: String?, imageUrl: String?, category: String?) {
        self.name = name
        self.imageUrl = imageUrl
        self.category = category    
    }
}

extension POIInfo: Hashable {
    static func == (lhs: POIInfo, rhs: POIInfo) -> Bool {
        return lhs.name == rhs.name &&
            lhs.imageUrl == rhs.imageUrl &&
            lhs.category == rhs.category
    }
}
