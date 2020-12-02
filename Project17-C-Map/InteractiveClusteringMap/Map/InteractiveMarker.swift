//
//  InteractiveMarker.swift
//  InteractiveClusteringMap
//
//  Created by eunjeong lee on 2020/11/29.
//

import Foundation
import NMapsMap

final class InteractiveMarker: NMFMarker, Markerable {
    
    required init(cluster: Cluster) {
        super.init()
        position = NMGLatLng(lat: cluster.center.y, lng: cluster.center.x)
        iconTintColor = .green
    }
    
}
