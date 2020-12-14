//
//  NMFMapView+Projection.swift
//  InteractiveClusteringMap
//
//  Created by Seungeon Kim on 2020/12/15.
//

import Foundation
import NMapsMap

extension NMFMapView {
    
    func project(from latlng: NMGLatLng) -> CGPoint {
        return projection.point(from: latlng)
    }
    
    func project(from point: CGPoint) -> NMGLatLng {
        return projection.latlng(from: point)
    }
    
}
