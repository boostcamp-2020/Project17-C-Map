//
//  ViewController.swift
//  InteractiveClusteringMap
//
//  Created by Oh Donggeon on 2020/11/16.
//

import UIKit
import CoreLocation
import NMapsMap

class MapViewController: UIViewController {

    @IBOutlet weak var interactiveMapView: InteractiveMapView!
    private let locationManager = CLLocationManager()
    private var mapController: MapController?
    private var dataManager: DataManagable?
    private var mapInteractor: MapInteractor?
    
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
        mapController = MapController(mapView: interactiveMapView)
        
        interactiveMapView.mapView.moveCamera(NMFCameraUpdate(scrollTo: NMGLatLng(lat: 37.56825785, lng: 126.9930027), zoomTo: 15))
        configureMapInteractor()
    }
    
    private func configureMapInteractor() {
        guard let dataManager = dataManager else { return }
        let poiService = POIService(dataManager: dataManager)
//        [126.9956437, 37.5764792, 126.9903617, 37.5600365]
        mapInteractor = MapInteractor(poiService: poiService)
        mapInteractor?.delegate = self
        mapInteractor?.fetch(boundingBox: BoundingBox(topRight: Coordinate(x: 126.9956437, y: 37.5764792), bottomLeft: Coordinate(x: 126.9903617, y: 37.5600365)), zoomLevel: 15)
    }
    
}

extension MapViewController: ClusterCompleteDelegate {
    
    func didComplete(clusters: [Cluster]) {
        mapController?.update(clusters: clusters)
    }
}
