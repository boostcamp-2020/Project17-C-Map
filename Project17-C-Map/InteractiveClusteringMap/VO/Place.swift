//
//  Place.swift
//  InteractiveClusteringMap
//
//  Created by Oh Donggeon on 2020/11/21.
//

import Foundation

struct Place {
    let coordinate: Coordinate
    let info: POIInfo
}

extension Place: Hashable {
    static func == (lhs: Place, rhs: Place) -> Bool {
        return lhs.coordinate == rhs.coordinate &&
            lhs.info == rhs.info
    }
}
