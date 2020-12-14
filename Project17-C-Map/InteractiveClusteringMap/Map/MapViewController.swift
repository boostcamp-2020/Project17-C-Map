//
//  ViewController.swift
//  InteractiveClusteringMap
//
//  Created by Oh Donggeon on 2020/11/16.
//

import UIKit
import CoreLocation
import NMapsMap

final class MapViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet private weak var interactiveMapView: InteractiveMapView!
    @IBOutlet private weak var placeListButton: UIButton!
    
    private let locationManager = CLLocationManager()
    private var mapController: MapController?
    private var dataManager: DataManagable?
    internal var transparentLayer: TransparentLayer?
    private var presentedMarkers: [NMFMarker] = []
    private var pickedMarker: LeafNodeMarker?
    
    let infoWindow = NMFInfoWindow()
    var customInfoWindowDataSource = CustomInfoWindowDataSource()
    private var polygonOverlay: NMFPolygonOverlay? = nil
    
    private var touchedDeleteLayer: Bool = false
    internal var isEditMode: Bool = false
    
    private var placeListViewController: PlaceListViewController?
    
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
        configureInfoWindow()
        configurePlaceListViewController()
        interactiveMapView.mapView.addCameraDelegate(delegate: self)
    }
    
    private func dependencyInject() {
        guard let dataManager = dataManager else { return }
        
        let poiService = POIService(dataManager: dataManager)
        let treeDataStore = TreeDataStore(poiService: poiService)
        let presenter: ClusterPresentationLogic = MapPresenter(createMarkerHandler: create, removeMarkerHandler: remove)
        let mapInteractor: MapBusinessLogic = MapInteractor(treeDataStore: treeDataStore, presenter: presenter)
        mapController = MapController(mapView: interactiveMapView, interactor: mapInteractor)
    }
    
    private func configureMap() {
        interactiveMapView?.mapView.touchDelegate = self
        interactiveMapView.mapView.moveCamera(NMFCameraUpdate(scrollTo: NMGLatLng(lat: 37.56825785, lng: 126.9930027), zoomTo: 15))
        
        transparentLayer = TransparentLayer(bounds: view.bounds)
        guard let transparentLayer = transparentLayer else { return }
        
        interactiveMapView.mapView.layer.addSublayer(transparentLayer)
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        gestureRecognizer.minimumPressDuration = 0.7
        interactiveMapView.addGestureRecognizer(gestureRecognizer)
    }
    
    private func configureInfoWindow() {
        infoWindow.anchor = CGPoint(x: 0, y: 1)
        infoWindow.dataSource = customInfoWindowDataSource
        infoWindow.offsetX = -40
        infoWindow.offsetY = -5
        infoWindow.touchHandler = { [weak self] (_) -> Bool in
            self?.infoWindow.close()
            return true
        }
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
                let alert = MapAlertController.createDeleteAlertController { [weak self] _ in
                    leafMarker.mapView = nil
                    leafMarker.markerLayer?.removeFromSuperlayer()
                    self?.presentedMarkers.remove(at: index)
                    self?.mapController?.delete(coordinate: leafMarker.coordinate)
                    
                    self?.touchedDeleteLayer = false
                }
                present(alert, animated: true)
            }
        }
    }
    
    @objc func handleLongPress(gesture: UILongPressGestureRecognizer) {
        guard gesture.state != .began && !isEditMode else { return }
        
        let pressedMarker = interactiveMapView.mapView.pick(gesture.location(in: interactiveMapView))
        
        if pressedMarker is LeafNodeMarker {
            showEditMode()
        } else if let clusterMarker = pressedMarker as? ClusteringMarker {
            polygonOverlay?.mapView = nil
            polygonOverlay = clusterMarker.createBoundingBoxPolygon()
            polygonOverlay?.mapView = interactiveMapView.mapView
            
        } else {
            addLeafNodeMarker(at: gesture.location(in: interactiveMapView))
        }
    }
    
    private func showEditMode() {
        isEditMode = true
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
        unableGestures()
        
        presentedMarkers.forEach { marker in
            guard let marker = marker as? LeafNodeMarker else { return }
            marker.hidden = true
            marker.createMarkerLayer()
            guard let leafNodeMarkerLayer = marker.markerLayer else { return }
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
    
    private func addLeafNodeMarker(at location: CGPoint) {
        let alert = MapAlertController.createAddAlertController { [weak self] text in
            guard let self = self else { return }
            
            let latlng = self.interactiveMapView.projectLatLng(from: location)
            let poi = POI(x: latlng.lng, y: latlng.lat, name: text)
            self.mapController?.add(poi: poi)
        }
        
        present(alert, animated: true)
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
                leafNodeMarker.createMarkerLayer()
                self.animate(marker: leafNodeMarker)
            
                let userInfo = mapController?.fetchInfo(by: leafNodeMarker.coordinate)
                leafNodeMarker.configureUserInfo(userInfo: userInfo)
                
                leafNodeMarker.touchHandler = { [weak self] (_) -> Bool in
                    guard let self = self else { return false }
                    
                    let userInfo = self.mapController?.fetchInfo(by: leafNodeMarker.coordinate)
                    leafNodeMarker.configureUserInfo(userInfo: userInfo)
                    
                    self.pickedMarker?.resizeMarkerSize()
                    leafNodeMarker.sizeUp()
                    self.pickedMarker = leafNodeMarker
                    self.infoWindow.open(with: leafNodeMarker)
                    return true
                }
                
            } else if let clusteringMarker = marker as? ClusteringMarker {
                self.setMarkersHandler(marker: clusteringMarker)
                self.animate(marker: clusteringMarker)
            }
        }
        updatePlaceListViewController()
    }
    
    private func remove(markers: [NMFMarker]) {
        markers.forEach { marker in
            marker.mapView = nil
            self.presentedMarkers.removeAll { $0 == marker }
            marker.touchHandler = nil
        }
    }
    
    private func animate(marker: NMFMarker) {
        var markerLayer: CALayer?
        var markerPosition: CGPoint?
        
        if let leafNodeMarker = marker as? LeafNodeMarker {
            markerLayer = leafNodeMarker.markerLayer
            markerPosition = interactiveMapView.projectPoint(from: NMGLatLng(lat: leafNodeMarker.coordinate.y,
                                                                             lng: leafNodeMarker.coordinate.x))
            
        } else if let clusteringMarker = marker as? ClusteringMarker {
            markerLayer = clusteringMarker.markerLayer
            markerPosition = interactiveMapView.projectPoint(from: NMGLatLng(lat: clusteringMarker.coordinate.y,
                                                                             lng: clusteringMarker.coordinate.x))
        }
        guard let layer = markerLayer,
              let position = markerPosition else { return }
        
        transparentLayer?.addSublayer(layer)
        marker.animate(position: position)
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
    
    func setMarkersHandler(marker: ClusteringMarker) {
        marker.touchHandler = { [weak self] _ in
            guard let self = self else { return true }
            
            self.polygonOverlay?.mapView = nil
            self.polygonOverlay = marker.createBoundingBoxPolygon()
            self.polygonOverlay?.mapView = self.interactiveMapView.mapView
            
            var cameraUpdate: NMFCameraUpdate?
            if marker.coordinatesCount <= 10000 {
                cameraUpdate = NMFCameraUpdate(fit: marker.boundingBox.boundingBoxToNMGBounds(),
                                               padding: 25)
            } else {
                cameraUpdate = NMFCameraUpdate(scrollTo: marker.position,
                                               zoomTo: self.interactiveMapView.zoomLevel + 2)
            }
            
            guard let update = cameraUpdate else { return false }
            
            update.animation = .easeOut
            update.animationDuration = 0.6
            self.interactiveMapView.mapView.moveCamera(update)
            let markerLayer = marker.markerLayer
            markerLayer.position = self.interactiveMapView.projectPoint(from: NMGLatLng(
                                                                            lat: marker.coordinate.y,
                                                                            lng: marker.coordinate.x))
            let markerAnimation = AnimationController.zoomTouchAnimation()
            markerLayer.opacity = 0
            self.transparentLayer?.addSublayer(markerLayer)
            
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
        
        infoWindow.close()
        isEditMode = false
        enableGestures()
        
        polygonOverlay?.mapView = nil
        transparentLayer?.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        presentedMarkers.forEach {
            $0.hidden = false
        }
        
        pickedMarker?.resizeMarkerSize()
    }
    
}

private extension MapViewController {
    
    @IBAction func placeListButtonTouched(_ sender: UIButton) {
        placeListButtonDisappear()
        placeListViewController?.show()
    }
    
    private func updatePlaceListViewController() {
        let clusters: [[Coordinate]] = presentedMarkers.compactMap {
            guard let marker = $0 as? ClusteringMarker else { return nil }
            return marker.cluster.coordinates
        }
        let coordinates: [Coordinate] = clusters.flatMap { $0 }
        let cluster = Cluster(coordinates: coordinates, boundingBox: .korea)
        placeListViewController?.requestPlaces(cluster: cluster)
    }
    
    private func placeListButtonDisappear() {
        CATransaction.begin()
        placeListButton.layer.opacity = 0
        CATransaction.setCompletionBlock {
            self.placeListButton.layer.isHidden = true
        }
        let animation = AnimationController.floatingButtonAnimation(option: .disapper)
        placeListButton.layer.add(animation, forKey: "floatingButtonDisappearAnimation")
        CATransaction.commit()
    }
    
    private func placeListButtonAppear() {
        CATransaction.begin()
        placeListButton.layer.opacity = 1
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.placeListButton.layer.isHidden = false
        }
        let animation = AnimationController.floatingButtonAnimation(option: .appear)
        placeListButton.layer.add(animation, forKey: "floatingButtonAppearAnimation")
        CATransaction.commit()
    }
    
}

private extension MapViewController {
    
    func configurePlaceListViewController() {
        guard let dataManager = dataManager else { return }
        
        let poiService = POIService(dataManager: dataManager)
        let geo = GeocodingNetwork(store: Store.http.dataProvider)
        let img = ImageProvider(localStore: Store.local.dataProvider, httpStore: Store.http.dataProvider)
        let service = PlaceInfoService(imageProvider: img, geocodingNetwork: geo)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        placeListViewController = storyboard.instantiateViewController(
            identifier: "PlaceListViewController",
            creator: { coder in
                return PlaceListViewController(coder: coder, poiService: poiService, placeInfoService: service)
            })
        guard let placeListViewController = placeListViewController else { return }
        
        placeListViewController.cancelButtonTouchedHandler = placeListButtonAppear
        placeListViewController.didMove(toParent: self)
        addChild(placeListViewController)
        view.addSubview(placeListViewController.view)
    }
    
}
