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
        configureMapController()
    }
    
    private func requestLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    private func configureMapController() {
        guard let dataManager = dataManager else { return }
    
        let service = POIService(dataManager: dataManager)
        mapController = MapController(mapView: interactiveMapView, poiServicing: service)
        mapController?.loadMarkers()
    }
     
}
