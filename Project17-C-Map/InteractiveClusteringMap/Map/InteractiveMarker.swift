//
//  InteractiveMarker.swift
//  InteractiveClusteringMap
//
//  Created by eunjeong lee on 2020/11/29.
//

import Foundation
import NMapsMap

final class InteractiveMarker: NMFMarker, Markerable, UIGestureRecognizerDelegate {
    
    required init(cluster: Cluster) {
        super.init()
        position = NMGLatLng(lat: cluster.center.y, lng: cluster.center.x)
        iconTintColor = .green
        
        let tapGesture = UILongPressGestureRecognizer()
        tapGesture.delegate = self
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        print("꾹")
        return true
    }
    func remove() {
        mapView = nil
    }
    
    
    
}
