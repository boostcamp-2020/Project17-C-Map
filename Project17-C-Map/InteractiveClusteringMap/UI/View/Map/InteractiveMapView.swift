//
//  InteractiveMapView.swift
//  InteractiveClusteringMap
//
//  Created by 박성민 on 2020/11/21.
//

import Foundation
import NMapsMap

final class InteractiveMapView: NMFNaverMapView {
    
    private lazy var transparentLayer: TransparentLayer = TransparentLayer(bounds: bounds)
    
    private var polygonOverlay: NMFPolygonOverlay?
    var mode: Mode = .normal {
        didSet {
            switch mode {
            case .edit:
                showEditMode()
            case .normal:
                enableGestures()
                removePolygon()
                removeAllFromTransparentLayer()
            }
        }
    }
    
    var showEditModeHandler: ((TransparentLayer) -> Void)?
    var longTouchedMarkerHandler: ((NMFPickable?, NMGLatLng) -> Void)?
    var removeLeafMarkerHandler: ((CGPoint) -> Void)?
    
    var zoomLevel: Double {
        mapView.zoomLevel
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mapView.layer.addSublayer(transparentLayer)
        configure()
        configureExtent()
    }
    
    private func configure() {
        showZoomControls = true
        showLocationButton = true
        showCompass = false
        showScaleBar = true
        mapView.allowsTilting = false
        mapView.isStopGestureEnabled = false
        mapView.minZoomLevel = 2
        mapView.moveCamera(NMFCameraUpdate(scrollTo: NMGLatLng(lat: 37.56825785, lng: 126.9930027), zoomTo: 15))
    }
    
    func addToTransparentLayer(_ layer: CALayer) {
        transparentLayer.addSublayer(layer)
    }
    
    func removeAllFromTransparentLayer() {
        transparentLayer.removeSublayers()
    }
    
    func removePolygon() {
        polygonOverlay?.mapView = nil
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch mode {
        case .normal:
            transparentLayer.removeSublayers()
            return
        case .edit:
            guard let touch = touches.first else { return }
            let point = touch.location(in: mapView)
            
            removeLeafMarkerHandler?(point)
        }
    }
    
}

// MARK: - Camera & Projection
extension InteractiveMapView {
    
    private func configureExtent() {
        let extent = NMGLatLngBounds(southWestLat: KoreaCoordinate.minLat,
                                     southWestLng: KoreaCoordinate.minLng,
                                     northEastLat: KoreaCoordinate.maxLat,
                                     northEastLng: KoreaCoordinate.maxLng)
        mapView.extent = extent
    }
    
    func moveCamera(position: NMGLatLng, boundingBox: BoundingBox, count: Int) {
        var cameraUpdate: NMFCameraUpdate?
        if count <= 10000 {
            cameraUpdate = NMFCameraUpdate(fit: boundingBox.boundingBoxToNMGBounds(),
                                           padding: 25)
        } else {
            cameraUpdate = NMFCameraUpdate(scrollTo: position,
                                           zoomTo: zoomLevel + 2)
        }
        
        guard let update = cameraUpdate else { return }
        
        update.animation = .easeOut
        update.animationDuration = 0.6
        mapView.moveCamera(update)
    }
    
}

// MARK: - Gesture
extension InteractiveMapView {
    
    func configureGesture() {
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        gestureRecognizer.minimumPressDuration = 0.7
        addGestureRecognizer(gestureRecognizer)
    }
    
    func enableGestures() {
        mapView.allowsScrolling = true
        mapView.allowsRotating = true
        mapView.allowsZooming = true
        showZoomControls = true
        showLocationButton = true
    }
    
    func unableGestures() {
        mapView.allowsScrolling = false
        mapView.allowsRotating = false
        mapView.allowsZooming = false
        showZoomControls = false
        showLocationButton = false
    }
    
    func drawPolygon(boundingBox: BoundingBox) {
        removePolygon()
        polygonOverlay = createBoundingBoxPolygon(boundingBox: boundingBox)
        polygonOverlay?.mapView = mapView
    }
    
    private func createBoundingBoxPolygon(boundingBox: BoundingBox) -> NMFPolygonOverlay? {
        let topRight = NMGLatLng(lat: boundingBox.topRight.y, lng: boundingBox.topRight.x)
        let bottomLeft = NMGLatLng(lat: boundingBox.bottomLeft.y, lng: boundingBox.bottomLeft.x)
        
        let coords = [bottomLeft,
                      NMGLatLng(lat: bottomLeft.lat, lng: topRight.lng),
                      topRight,
                      NMGLatLng(lat: topRight.lat, lng: bottomLeft.lng),
                      bottomLeft]
        
        let polygon = NMGPolygon(ring: NMGLineString(points: coords)) as NMGPolygon<AnyObject>
        let polygonOverlay = NMFPolygonOverlay(polygon)
        
        polygonOverlay?.fillColor = UIColor(named: "polygon") ?? UIColor.red
        polygonOverlay?.outlineWidth = 1
        
        return polygonOverlay
    }
    
    @objc func handleLongPress(gesture: UILongPressGestureRecognizer) {
        guard gesture.state != .began && mode == .normal else { return }
        
        let pressedMarker = mapView.pick(gesture.location(in: self))
        let location = gesture.location(in: self)
        let latLng = mapView.project(from: location)
        longTouchedMarkerHandler?(pressedMarker, latLng)
    }
    
}

extension InteractiveMapView {
    
    func showEditMode() {
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
        unableGestures()
        showEditModeHandler?(transparentLayer)
    }
    
}

extension InteractiveMapView {
    
    enum Mode {
        case edit
        case normal
    }
    
}
