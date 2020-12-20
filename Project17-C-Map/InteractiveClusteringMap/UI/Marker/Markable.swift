//
//  Marker.swift
//  InteractiveClusteringMap
//
//  Created by eunjeong lee on 2020/12/20.
//

import Foundation
import NMapsMap

protocol Markable {
    
    var coordinate: Coordinate { get }
    var markerLayer: CALayer { get }
    var naverMapView: NMFMapView? { get }
    
    func animate(position: CGPoint)
    
}
