//
//  NMGLatLngBounds+BoundingBox.swift
//  InteractiveClusteringMap
//
//  Created by A on 2020/12/10.
//

import Foundation
import NMapsMap

extension NMGLatLngBounds {
    
    private enum Index {
        static let BL: Int = 0
        static let TR: Int = 1
    }
    
    func makeBoundingBox() -> BoundingBox {
        let BL = self.boundsLatLngs[Index.BL]
        let TR = self.boundsLatLngs[Index.TR]
        
        let bottomLeft = Coordinate(x: BL.lng, y: BL.lat)
        let topRight = Coordinate(x: TR.lng, y: TR.lat)
        
        return BoundingBox(topRight: topRight, bottomLeft: bottomLeft)
    }
    
}
