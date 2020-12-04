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
        
        touchHandler = { (_) -> Bool in
            print("마커 터치")
            return true
        }
        
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        print("꾹")
        return true
    }
    func remove() {
        mapView = nil
    }
    
    
    
}
