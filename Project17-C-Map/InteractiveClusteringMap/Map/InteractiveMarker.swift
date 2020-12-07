//
//  InteractiveMarker.swift
//  InteractiveClusteringMap
//
//  Created by eunjeong lee on 2020/11/29.
//

import Foundation
import NMapsMap

final class InteractiveMarker: NMFMarker, Markerable, UIGestureRecognizerDelegate {
    
    private(set) var coordinate: Coordinate
    
    init(coordinate: Coordinate) {
        self.coordinate = coordinate
        super.init()
        
        position = NMGLatLng(lat: coordinate.y, lng: coordinate.x)
        iconTintColor = .green
        
        let tapGesture = UILongPressGestureRecognizer()
        tapGesture.delegate = self
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func remove() {
        mapView = nil
    }
    
}
