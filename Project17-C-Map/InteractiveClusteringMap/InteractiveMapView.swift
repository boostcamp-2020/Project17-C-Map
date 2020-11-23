//
//  InteractiveMapView.swift
//  InteractiveClusteringMap
//
//  Created by 박성민 on 2020/11/21.
//

import Foundation
import NMapsMap

final class InteractiveMapView: NMFNaverMapView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
       
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }
    
    private func configure() {
        showZoomControls = true
        showLocationButton = true
        showCompass = true
        showScaleBar = true
        
        mapView.minZoomLevel = ZoomLevel.min
        mapView.maxZoomLevel = ZoomLevel.max
        configureExtent()
    }
    
    private func configureExtent() {
        let extent = NMGLatLngBounds(southWestLat: Metric.southWestLat,
                                     southWestLng: Metric.southWestLng,
                                     northEastLat: Metric.northEastLat,
                                     northEastLng: Metric.northEastLng)
        mapView.extent = extent
    }
    
}

private extension InteractiveMapView {
    
    enum Metric {
        static let southWestLat: Double = 35
        static let southWestLng: Double = 126
        static let northEastLat: Double = 40
        static let northEastLng: Double = 128.0
    }
    
    enum ZoomLevel {
        static let min: Double = 5
        static let max: Double = 19
    }
    
}
