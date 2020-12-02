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
        interactiveMapView.mapView.addCameraDelegate(delegate: self)
        transparentLayer = TransparentLayer(bounds: view.bounds)
        interactiveMapView.mapView.layer.addSublayer(transparentLayer!)
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
    }
    
    private func createMarkers(markers: [Markerable]) {
        markers.forEach { marker in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                if let clusteringMarkerLayer = marker as? ClusteringMarkerLayer {
                    clusteringMarkerLayer.setScreenPosition(mapView: self.interactiveMapView.mapView)
                    self.transparentLayer?.addSublayer(clusteringMarkerLayer)
                } else if let interactiveMaker = marker as? InteractiveMarker {
                    interactiveMaker.mapView = self.interactiveMapView.mapView
                }
            }
        }
    }
    
    private func removeMarkers(markers: [Markerable]) {
        markers.forEach { marker in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                if let clusteringMarkerLayer = marker as? ClusteringMarkerLayer {
                    clusteringMarkerLayer.removeFromSuperlayer()
                } else if let interactiveMaker = marker as? InteractiveMarker {
                    interactiveMaker.mapView = nil
                }
            }
        }
    }
    
}

extension MapViewController: NMFMapViewCameraDelegate {
    func mapView(_ mapView: NMFMapView, cameraIsChangingByReason reason: Int) {
        
    }
    
    func mapView(_ mapView: NMFMapView, cameraWillChangeByReason reason: Int, animated: Bool) {
        //        animationController?.subLayer.position = interactiveMapView.mapView.projection.point(from: NMGLatLng(lat: 37.45219245759162, lng: 126.65371209878728))
    }
    
    func mapView(_ mapView: NMFMapView, cameraDidChangeByReason reason: Int, animated: Bool) {
        print("ended")
        //        animationController?.subLayer.position = interactiveMapView.mapView.projection.point(from: NMGLatLng(lat: 37.45219245759162, lng: 126.65371209878728))
    }
    
    func mapViewCameraIdle(_ mapView: NMFMapView) {
        //        animationController?.subLayer.position = interactiveMapView.mapView.projection.point(from: NMGLatLng(lat: 37.45219245759162, lng: 126.65371209878728))
    }
}
