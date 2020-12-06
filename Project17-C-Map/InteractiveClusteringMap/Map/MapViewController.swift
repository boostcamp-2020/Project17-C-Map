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
    private let infoWindowForDelete = NMFInfoWindow()
    private let dataSourceForDelete = NMFInfoWindowDefaultTextSource.data()
    internal let infoWindowForAdd = NMFInfoWindow()
    private let dataSourceForAdd = NMFInfoWindowDefaultTextSource.data()
    
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
    }
    
    private func dependencyInject() {
        guard let dataManager = dataManager else { return }
        
        let poiService = POIService(dataManager: dataManager)
        let presenter: ClusterPresentationLogic = MapPresenter(createMarkerHandler: create, removeMarkerHandler: remove)
        let mapInteractor: ClusterBusinessLogic = MapInteractor(poiService: poiService, presenter: presenter)
        mapController = MapController(mapView: interactiveMapView, interactor: mapInteractor)
    }
    
    private func configureInfoWindow() {
        interactiveMapView?.mapView.touchDelegate = self
        dataSourceForDelete.title = "삭제"
        infoWindowForDelete.dataSource = dataSourceForDelete
        dataSourceForAdd.title = "추가"
        infoWindowForAdd.dataSource = dataSourceForAdd
        
        infoWindowForDelete.touchHandler = { [weak self] (_) -> Bool in
            self?.infoWindowForDelete.close()
            let alert = MapAlertController(alertType: .delete) { _ in
                
            }
            self?.present(alert.createAlertController(), animated: true)
            return true
        }
        
        infoWindowForAdd.touchHandler = { [weak self] (_) -> Bool in
            let alert = MapAlertController(alertType: .add, okHandler: nil)
            self?.present(alert.createAlertController(), animated: true)
            return true
        }
    }
    
    private func configureMap() {
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
        
        interactiveMapView.mapView.addCameraDelegate(delegate: self)
        
        transparentLayer = TransparentLayer(bounds: view.bounds)
        guard let transparentLayer = transparentLayer else { return }
        
        interactiveMapView.mapView.layer.addSublayer(transparentLayer)
        
    }
    
    internal func setMarkerPosition(marker: CALayer) {
        guard let marker = marker as? ClusteringMarkerLayer else { return }
        
        let latLng = NMGLatLng(lat: marker.coordinate.y, lng: marker.coordinate.x)
        marker.updatePosition(position: interactiveMapView.projectPoint(from: latLng))
    }
    
    private func create(markers: [NMFMarker]) {
        markers.forEach { marker in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                marker.mapView = self.interactiveMapView.mapView
                marker.hidden = true
                
                if let leafNodeMarker = marker as? LeafNodeMarker {
                    self.animate(marker: leafNodeMarker)
                    
                } else if let interactiveMarker = marker as? InteractiveMarker {
                    interactiveMarker.touchHandler = { [weak self] (_) -> Bool in
                        self?.infoWindowForAdd.close()
                        self?.infoWindowForDelete.open(with: interactiveMarker)
                        return true
                    }
                    self.animate(marker: interactiveMarker)
                }
            }
        }
    }
    
    private func remove(markers: [NMFMarker]) {
        markers.forEach { marker in
            DispatchQueue.main.async {
                marker.mapView = nil
            }
        }
    }
    
    private func animate(marker: NMFMarker) {
        var markerLayer: CALayer?
        var markerAnimation: CAAnimation?
        
        if let leafNodeMarker = marker as? LeafNodeMarker {
            markerLayer = leafNodeMarker.markerLayer
            let position = interactiveMapView.projectPoint(from: NMGLatLng(lat: leafNodeMarker.coordinate.y,
                                                                        lng: leafNodeMarker.coordinate.x))
            markerLayer?.position = CGPoint(x: position.x, y: position.y - ((markerLayer?.bounds.height ?? 0) / 2))
            markerAnimation = AnimationController.transformScale(option: .increase)
        
        } else if let interactiveMarker = marker as? InteractiveMarker {
            markerLayer = interactiveMarker.markerLayer
            markerLayer?.position = interactiveMapView.projectPoint(from: NMGLatLng(lat: interactiveMarker.coordinate.y,
                                                                                lng: interactiveMarker.coordinate.x))
            markerAnimation = AnimationController.transformScale(option: .increase)
        }
        guard let layer = markerLayer else { return }
        guard let animation = markerAnimation else { return }
        
        transparentLayer?.addSublayer(layer)
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            markerLayer?.removeFromSuperlayer()
            marker.hidden = false
        }
        markerLayer?.add(animation, forKey: "markerAnimation")
        CATransaction.commit()
    }
    
}

extension MapViewController: NMFMapViewTouchDelegate {
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        infoWindowForAdd.close()
        infoWindowForDelete.close()
        infoWindowForAdd.position = latlng
        infoWindowForAdd.open(with: mapView)
    }
}
