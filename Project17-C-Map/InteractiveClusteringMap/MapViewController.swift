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
    private var mapController: MapController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestLocationPermission()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func requestLocationPermission(){
        let locationManger = CLLocationManager()
        locationManger.requestWhenInUseAuthorization()
    }
    
}
