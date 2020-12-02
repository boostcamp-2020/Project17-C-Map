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
    
    @IBOutlet weak var interactiveMapView: InteractiveMapView!
    private let locationManager = CLLocationManager()
    private var mapController: MapController?
    private var dataManager: DataManagable?
    private var transparentLayer: TransparentLayer?
    
    init?(coder: NSCoder, dataManager: DataManagable) {
        self.dataManager = dataManager
        super.init(coder: coder)
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
        let presenter: ClusterPresentationLogic = MapPresenter(createMarkerHandler: createMarkers, removeMarkerHandler: removeMarkers)
        let mapInteractor: ClusterBusinessLogic = MapInteractor(poiService: poiService, presenter: presenter)
        mapController = MapController(mapView: interactiveMapView, interactor: mapInteractor)
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
    
    private func setMarkerPosition(marker: CALayer) {
        guard let marker = marker as? ClusteringMarkerLayer else { return }
        
        let latLng = NMGLatLng(lat: marker.center.y, lng: marker.center.x)
        marker.setScreenPosition(position: self.interactiveMapView.mapView.projection.point(from: latLng))
    }
    
    private func createMarkers(markers: [Markerable]) {
        markers.forEach { marker in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                if let clusteringMarkerLayer = marker as? ClusteringMarkerLayer {
                    self.setMarkerPosition(marker: clusteringMarkerLayer)
                    
                    let animation = AnimationController.fadeInOut(inOut: true)
                    clusteringMarkerLayer.add(animation, forKey: "fadeIn")
                    
                    self.transparentLayer?.addSublayer(clusteringMarkerLayer)
                } else if let interactiveMaker = marker as? InteractiveMarker {
                    interactiveMaker.mapView = self.interactiveMapView.mapView
                }
            }
        }
    }
    
    private func removeMarkers(markers: [Markerable]) {
        markers.forEach { marker in
            DispatchQueue.main.async {
                if let clusteringMarkerLayer = marker as? ClusteringMarkerLayer {
                    let animation = AnimationController.fadeInOut(inOut: false)
                    
                    clusteringMarkerLayer.add(animation, forKey: "fadeOut")
                    DispatchQueue.main.asyncAfter(deadline: .now() + animation.duration - 0.4) {
                        clusteringMarkerLayer.removeFromSuperlayer()
                    }
                } else if let interactiveMaker = marker as? InteractiveMarker {
                    interactiveMaker.mapView = nil
                }
            }
        }
    }
    
}

extension MapViewController: NMFMapViewCameraDelegate {
    func mapView(_ mapView: NMFMapView, cameraIsChangingByReason reason: Int) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.transparentLayer?.sublayers?.forEach { subLayer in
                self.setMarkerPosition(marker: subLayer)
            }
        }
    }
    
    func mapView(_ mapView: NMFMapView, cameraWillChangeByReason reason: Int, animated: Bool) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.transparentLayer?.sublayers?.forEach { subLayer in
                self.setMarkerPosition(marker: subLayer)
            }
        }
    }
    
    func mapView(_ mapView: NMFMapView, cameraDidChangeByReason reason: Int, animated: Bool) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.transparentLayer?.sublayers?.forEach { subLayer in
                self.setMarkerPosition(marker: subLayer)
            }
        }
    }
    
    func mapViewCameraIdle(_ mapView: NMFMapView) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.transparentLayer?.sublayers?.forEach { subLayer in
                self.setMarkerPosition(marker: subLayer)
            }
        }
    }
}
