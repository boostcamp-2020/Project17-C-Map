//
//  InteractiveMapView.swift
//  InteractiveClusteringMap
//
//  Created by 박성민 on 2020/11/21.
//

import Foundation
import NMapsMap

final class InteractiveMapView: NMFNaverMapView {
    
    var zoomLevel: Double {
        mapView.zoomLevel
    }
    
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
        mapView.allowsTilting = false
        mapView.minZoomLevel = 2
        
        configureExtent()
    }
    
    private func configureExtent() {
        let extent = NMGLatLngBounds(southWestLat: Metric.southWestLat,
                                     southWestLng: Metric.southWestLng,
                                     northEastLat: Metric.northEastLat,
                                     northEastLng: Metric.northEastLng)
        mapView.extent = extent
    }
    
    func projectPoint(from latlng: NMGLatLng) -> CGPoint {
        return mapView.projection.point(from: latlng)
    }
    
    func projectLatLng(from point: CGPoint) -> NMGLatLng {
        return mapView.projection.latlng(from: point)
    }
    
}

private extension InteractiveMapView {
    
    enum Metric {
        static let southWestLat: Double = 33
        static let southWestLng: Double = 124
        static let northEastLat: Double = 43
        static let northEastLng: Double = 132
    }
    
}
