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
    
    private let locationManager = CLLocationManager()
    private var mapController: MapController?
    private var dataManager: DataManagable?
    internal var transparentLayer: TransparentLayer?
    private var presentedMarkers: [NMFMarker] = []
    private var pickedMarker: LeafNodeMarker? = nil
    
    let infoWindow = NMFInfoWindow()
    var customInfoWindowDataSource = CustomInfoWindowDataSource()
    private var polygonOverlay: NMFPolygonOverlay? = nil
    
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
        configureInfoWindow()
        
        testMock()
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
                let alert = MapAlertController(alertType: .delete, okHandler: { [weak self] _ in
                    leafMarker.mapView = nil
                    leafMarker.markerLayer?.removeFromSuperlayer()
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
        guard gesture.state != .began && !isEditMode else { return }
        
        let pressedMarker = interactiveMapView.mapView.pick(gesture.location(in: interactiveMapView))
        
        if pressedMarker is LeafNodeMarker {
            showEditMode()
        } else if let clusterMarker = pressedMarker as? ClusteringMarker {
            showBoundingBox(marker: clusterMarker)
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
        let alert = MapAlertController(alertType: .add, okHandler: { [weak self] _ in
            guard let self = self else { return }
            
            let latlng = self.interactiveMapView.projectLatLng(from: location)
            self.mapController?.add(coordinate: Coordinate(x: latlng.lng, y: latlng.lat))
        }, cancelHandler: nil)
        
        present(alert.createAlertController(), animated: true)
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
    }
    
    private func remove(markers: [NMFMarker]) {
        markers.forEach { marker in
            marker.mapView = nil
            self.presentedMarkers.removeAll { $0 == marker }
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
            
            self.showBoundingBox(marker: marker)
            
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
    
    func testMock() {
        guard let dataManager = dataManager else { return }
        let poiService = POIService(dataManager: dataManager)
        let geo = GeocodingNetwork(store: Store.http.dataProvider)
        let img = ImageProvider(localStore: Store.local.dataProvider, httpStore: Store.http.dataProvider)
        let service = PlaceInfoService(imageProvider: img, geocodingNetwork: geo)
        
        let coord = Coordinate(x: 127.1054065, y: 37.3595669)
        let coord1 = Coordinate(x: 127.1054065, y: 37.359568)
        let coord2 = Coordinate(x: 127.1054065, y: 37.35957)
        let coord3 = Coordinate(x: 127.1054065, y: 37.359572)
        let coord4 = Coordinate(x: 127.1054065, y: 37.359574)
        let coord5 = Coordinate(x: 127.1054065, y: 37.359576)
        let coord6 = Coordinate(x: 127.1054065, y: 37.359578)
        let coord7 = Coordinate(x: 127.1054065, y: 37.35958)
        let coord8 = Coordinate(x: 127.1054065, y: 37.359582)
        let coord9 = Coordinate(x: 127.1054065, y: 37.359584)
        let coord10 = Coordinate(x: 127.1054065, y: 37.359586)
        
        var places: Cluster = Cluster(coordinates: [], boundingBox: BoundingBox.korea)
        
        places.coordinates.append(coord)
        places.coordinates.append(coord1)
        places.coordinates.append(coord2)
        places.coordinates.append(coord3)
        places.coordinates.append(coord4)
        places.coordinates.append(coord5)
        places.coordinates.append(coord6)
        places.coordinates.append(coord7)
        places.coordinates.append(coord8)
        places.coordinates.append(coord9)
        places.coordinates.append(coord10)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let previewViewController = storyboard.instantiateViewController(
            identifier: "PlaceListViewController",
            creator: { coder in
                return PlaceListViewController(coder: coder, cluster: places, poiService: poiService, placeInfoService: service)
            })
        
        let height = view.frame.height
        let width  = view.frame.width
        previewViewController.view.frame = CGRect(x: 0, y: self.view.frame.maxY, width: width, height: height)
        previewViewController.didMove(toParent: self)
        self.addChild(previewViewController)
        self.view.addSubview(previewViewController.view)
    }
    
}

extension MapViewController {
    
    func showBoundingBox(marker: ClusteringMarker) {
        polygonOverlay?.mapView = nil
        
        let TopRight = NMGLatLng(lat: marker.boundingBox.topRight.y, lng: marker.boundingBox.topRight.x)
        let BottomLeft = NMGLatLng(lat: marker.boundingBox.bottomLeft.y, lng: marker.boundingBox.bottomLeft.x)
        
        let coords = [BottomLeft,
                       NMGLatLng(lat: BottomLeft.lat, lng: TopRight.lng),
                       TopRight,
                       NMGLatLng(lat: TopRight.lat, lng: BottomLeft.lng),
                       BottomLeft]
        
        let polygon = NMGPolygon(ring: NMGLineString(points: coords)) as NMGPolygon<AnyObject>
        polygonOverlay = NMFPolygonOverlay(polygon)
        
        polygonOverlay?.fillColor = UIColor(red: 25.0/255.0, green: 192.0/255.0, blue: 46.0/255.0, alpha: 41.0/255.0)
        polygonOverlay?.outlineWidth = 1
        polygonOverlay?.mapView = interactiveMapView.mapView
    }
    
}
