//
//  MapViewController+NMFMapViewCameraDelegate.swift
//  InteractiveClusteringMap
//
//  Created by 박성민 on 2020/12/13.
//

import Foundation
import NMapsMap

extension MapViewController: NMFMapViewCameraDelegate {
    
    func mapView(_ mapView: NMFMapView, cameraIsChangingByReason reason: Int) {
        interactiveMapView.removeAllFromTransparentLayer()
    }
    
    func mapView(_ mapView: NMFMapView, cameraDidChangeByReason reason: Int, animated: Bool) {
        interactiveMapView.removeAllFromTransparentLayer()
    }
    
    func mapView(_ mapView: NMFMapView, cameraWillChangeByReason reason: Int, animated: Bool) {
        interactiveMapView.removeAllFromTransparentLayer()
    }
    
    func mapViewCameraIdle(_ mapView: NMFMapView) {
        interactiveMapView.removeAllFromTransparentLayer()
    }
}
