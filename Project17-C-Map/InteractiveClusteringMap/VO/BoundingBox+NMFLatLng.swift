//
//  BoundingBox+NMFLatLng.swift
//  InteractiveClusteringMap
//
//  Created by eunjeong lee on 2020/12/19.
//

import Foundation
import NMapsMap

extension BoundingBox {
    
    func boundingBoxToNMGBounds() -> NMGLatLngBounds {
        let southWest = NMGLatLng(lat: bottomLeft.y, lng: bottomLeft.x)
        let northEast = NMGLatLng(lat: topRight.y, lng: topRight.x)
        
        return NMGLatLngBounds(southWest: southWest, northEast: northEast)
    }
    
}
