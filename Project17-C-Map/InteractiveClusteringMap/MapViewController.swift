//
//  ViewController.swift
//  InteractiveClusteringMap
//
//  Created by Oh Donggeon on 2020/11/16.
//

import UIKit
import CoreLocation

class MapViewController: UIViewController {

    @IBOutlet weak var mainMapView: InteractiveMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let locationManger = CLLocationManager()
        locationManger.requestWhenInUseAuthorization()
    }
    
}
