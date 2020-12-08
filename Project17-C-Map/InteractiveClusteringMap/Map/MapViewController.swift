//
//  ViewController.swift
//  InteractiveClusteringMap
//
//  Created by Oh Donggeon on 2020/11/16.
//

import UIKit
import CoreLocation
import NMapsMap

final class MapViewController: UIViewController {
    
    @IBOutlet private weak var interactiveMapView: InteractiveMapView!
    
    private let locationManager = CLLocationManager()
    private var mapController: MapController?
    private var dataManager: DataManagable?
    internal var transparentLayer: TransparentLayer?
    private var presentedMarkers: [NMFMarker] = []
    
    private var touchedDeleteLayer: Bool = false
    internal var isEditMode: Bool = false
    
    init?(coder: NSCoder, dataManager: DataManagable) {
        super.init(coder: coder)
        self.dataManager = dataManager
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization()
        dependencyInject()
        configureMap()
    }
    
    private func dependencyInject() {
        guard let dataManager = dataManager else { return }
        
        let poiService = POIService(dataManager: dataManager)
        let treeDataStore = TreeDataStore(poiService: poiService)
        let presenter: ClusterPresentationLogic = MapPresenter(createMarkerHandler: create, removeMarkerHandler: remove)
        let mapInteractor: ClusterBusinessLogic = MapInteractor(treeDataStore: treeDataStore, presenter: presenter)
        mapController = MapController(mapView: interactiveMapView, interactor: mapInteractor)
    }
    
    private func configureMap() {
        interactiveMapView?.mapView.touchDelegate = self
        
        interactiveMapView.mapView.moveCamera(NMFCameraUpdate(scrollTo: NMGLatLng(lat: 37.56825785, lng: 126.9930027), zoomTo: 15))
        
        let coords1 = [NMGLatLng(lat: 37.5764792, lng: 126.9956437),
                       NMGLatLng(lat: 37.5600365, lng: 126.9956437),
                       NMGLatLng(lat: 37.5600365, lng: 126.9903617),
                       NMGLatLng(lat: 37.5764792, lng: 126.9903617),
                       NMGLatLng(lat: 37.5764792, lng: 126.9956437)]
        
        let polygon = NMGPolygon(ring: NMGLineString(points: coords1)) as NMGPolygon<AnyObject>
        let polygonOverlay = NMFPolygonOverlay(polygon)
        polygonOverlay?.fillColor = UIColor(red: 25.0/255.0, green: 192.0/255.0, blue: 46.0/255.0, alpha: 31.0/255.0)
        polygonOverlay?.outlineWidth = 3
        polygonOverlay?.mapView = interactiveMapView.mapView

        transparentLayer = TransparentLayer(bounds: view.bounds)
        guard let transparentLayer = transparentLayer else { return }
        
        interactiveMapView.mapView.layer.addSublayer(transparentLayer)
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        gestureRecognizer.minimumPressDuration = 0.7
        interactiveMapView.addGestureRecognizer(gestureRecognizer)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let sublayers = transparentLayer?.sublayers else { return }
        if !isEditMode {
            sublayers.forEach { sublayer in
                sublayer.removeAllAnimations()
                sublayer.removeFromSuperlayer()
            }
        }
        guard isEditMode else { return }
        guard let touch = touches.first else { return }
        let point = touch.location(in: interactiveMapView.mapView)
        
        for (index, marker) in presentedMarkers.enumerated() {
            guard let leafMarker = marker as? LeafNodeMarker else { continue }
            
            let editButtonRange = interactiveMapView.projectPoint(from: NMGLatLng(lat: leafMarker.coordinate.y, lng: leafMarker.coordinate.x))
            let x = editButtonRange.x - leafMarker.iconImage.imageWidth / 2
            let y = editButtonRange.y - leafMarker.iconImage.imageHeight
            
            let containX = (x..<x + 30).contains(point.x)
            let containY = (y..<y + 30).contains(point.y)
            
            if containX && containY {
                touchedDeleteLayer = true
                let alert = MapAlertController(alertType: .delete, okHandler: { [weak self] _ in
                    leafMarker.mapView = nil
                    leafMarker.markerLayer.removeFromSuperlayer()
                    self?.presentedMarkers.remove(at: index)
                    self?.mapController?.delete(coordinate: leafMarker.coordinate)
                    
                    self?.touchedDeleteLayer = false
                }, cancelHandler: { [weak self] _ in
                    self?.touchedDeleteLayer = false
                })
                present(alert.createAlertController(), animated: true)
            }
        }
    }
    
    @objc func handleLongPress(gesture: UILongPressGestureRecognizer) {
        guard gesture.state != .began && !isEditMode else {
            return
        }
        if isMarkerLongPressed(gesture: gesture) {
            showMarkerEditMode()
        }
    }
    
    private func isMarkerLongPressed(gesture: UILongPressGestureRecognizer) -> Bool {
        for marker in presentedMarkers {
            if let leafMarker = marker as? LeafNodeMarker {
                let markerScreenCoordinate = interactiveMapView.projectPoint(from: leafMarker.position)
                let markerMinX = markerScreenCoordinate.x - (leafMarker.iconImage.imageWidth / 2) - 5
                let markerMaxX = markerScreenCoordinate.x + (leafMarker.iconImage.imageWidth / 2) + 5
                let markerMinY = markerScreenCoordinate.y - (leafMarker.iconImage.imageHeight / 2) - 30
                let markerMaxY = markerScreenCoordinate.y
                
                let containX = (markerMinX..<markerMaxX).contains(gesture.location(in: interactiveMapView).x)
                let containY = (markerMinY..<markerMaxY).contains(gesture.location(in: interactiveMapView).y)
                if containX && containY {
                    isEditMode = true
                    let generator = UIImpactFeedbackGenerator(style: .heavy)
                    generator.impactOccurred()
                    
                    return true
                }
            }
        }
        return false
    }
    
    private func showMarkerEditMode() {
        unableGestures()
        
        presentedMarkers.forEach { marker in
            guard let marker = marker as? LeafNodeMarker else { return }
            marker.hidden = true
            let leafNodeMarkerLayer = marker.markerLayer
            leafNodeMarkerLayer.bounds = CGRect(x: 0, y: 0,
                                                width: marker.iconImage.imageWidth,
                                                height: marker.iconImage.imageHeight)
            leafNodeMarkerLayer.contents = marker.iconImage.image.cgImage
            leafNodeMarkerLayer.addEditButtonLayer()
            transparentLayer?.addSublayer(leafNodeMarkerLayer)
            leafNodeMarkerLayer.position = self.interactiveMapView.projectPoint(from: NMGLatLng(lat: marker.coordinate.y, lng: marker.coordinate.x))
            leafNodeMarkerLayer.editButtonLayer.position = CGPoint(x: 8, y: 8)
            leafNodeMarkerLayer.animate()
        }
    }
    
    internal func setMarkerPosition(marker: CALayer) {
        guard let marker = marker as? ClusteringMarkerLayer else { return }
        
        let latLng = NMGLatLng(lat: marker.coordinate.y, lng: marker.coordinate.x)
        marker.updatePosition(position: interactiveMapView.projectPoint(from: latLng))
    }
    
    private func create(markers: [NMFMarker]) {
        markers.forEach { marker in
            marker.mapView = self.interactiveMapView.mapView
            marker.hidden = true
            self.presentedMarkers.append(marker)
            
            if let leafNodeMarker = marker as? LeafNodeMarker {
                self.animate(marker: leafNodeMarker)
            } else if let interactiveMarker = marker as? InteractiveMarker {
                self.setMarkersHandler(marker: interactiveMarker)
                self.animate(marker: interactiveMarker)
            }
            
        }
    }
    
    private func remove(markers: [NMFMarker]) {
        markers.forEach { marker in
            marker.mapView = nil
            self.presentedMarkers.removeAll { $0 == marker }
        }
    }
    
    private func animate(marker: NMFMarker) {
        var markerLayer: CALayer?
        var markerAnimation: CAAnimation?
        
        if let leafNodeMarker = marker as? LeafNodeMarker {
            markerLayer = leafNodeMarker.markerLayer
            guard let markerLayer = markerLayer else { return }
            
            markerLayer.anchorPoint = CGPoint(x: 0.5, y: 1)
            markerLayer.position = interactiveMapView.projectPoint(from: NMGLatLng(lat: leafNodeMarker.coordinate.y,
                                                                                   lng: leafNodeMarker.coordinate.x))
            markerAnimation = AnimationController.leafNodeAnimation(position: markerLayer.position)
            
        } else if let interactiveMarker = marker as? InteractiveMarker {
            markerLayer = interactiveMarker.markerLayer
            markerLayer?.position = interactiveMapView.projectPoint(from: NMGLatLng(lat: interactiveMarker.coordinate.y,
                                                                                    lng: interactiveMarker.coordinate.x))
            markerAnimation = AnimationController.transformScale(option: .increase)
        }
        guard let layer = markerLayer,
              let animation = markerAnimation else { return }
        
        transparentLayer?.addSublayer(layer)
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        CATransaction.setCompletionBlock {
            markerLayer?.removeFromSuperlayer()
            marker.hidden = false
        }
        markerLayer?.add(animation, forKey: "markerAnimation")
        CATransaction.commit()
    }
    
    private func enableGestures() {
        interactiveMapView.mapView.allowsScrolling = true
        interactiveMapView.mapView.allowsRotating = true
        interactiveMapView.mapView.allowsZooming = true
        interactiveMapView.showZoomControls = true
        interactiveMapView.showLocationButton = true
    }
    
    private func unableGestures() {
        interactiveMapView.mapView.allowsScrolling = false
        interactiveMapView.mapView.allowsRotating = false
        interactiveMapView.mapView.allowsZooming = false
        interactiveMapView.showZoomControls = false
        interactiveMapView.showLocationButton = false
    }
    
    func setMarkersHandler(marker: InteractiveMarker) {
        marker.touchHandler = { [weak self] _ in
            guard let self = self else { return true }
            let southWest = NMGLatLng(lat: marker.boundingBox.bottomLeft.y, lng: marker.boundingBox.bottomLeft.x)
            let northEast = NMGLatLng(lat: marker.boundingBox.topRight.y, lng: marker.boundingBox.topRight.x)
            let bounds = NMGLatLngBounds(southWest: southWest, northEast: northEast)
            let cameraUpdate = NMFCameraUpdate(fit: bounds, padding: 25)
            
            cameraUpdate.animation = .easeOut
            cameraUpdate.animationDuration = 0.6
            
            let markerLayer = marker.markerLayer
            markerLayer.position = self.interactiveMapView.projectPoint(from: NMGLatLng(
                                                                            lat: marker.coordinate.y,
                                                                            lng: marker.coordinate.x))
            let markerAnimation = AnimationController.zoomTouchAnimation()
            markerLayer.opacity = 0
            self.transparentLayer?.addSublayer(markerLayer)
            self.interactiveMapView.mapView.moveCamera(cameraUpdate)
            CATransaction.begin()
            marker.hidden = true
            CATransaction.setCompletionBlock {
                markerLayer.removeFromSuperlayer()
            }
            markerLayer.add(markerAnimation, forKey: "dismissMarker")
            CATransaction.commit()
            
            return true
        }
    }
    
}

extension MapViewController: NMFMapViewTouchDelegate {
    
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        guard !touchedDeleteLayer else { return }
        
        isEditMode = false
        enableGestures()
        
        self.transparentLayer?.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        presentedMarkers.forEach {
            $0.hidden = false
        }
    }
    
}
