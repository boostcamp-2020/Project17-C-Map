//
//  MapViewController+NMFMapViewCameraDelegate.swift
//  InteractiveClusteringMap
//
//  Created by 박성민 on 2020/12/16.
//

import NMapsMap

extension MapViewController: NMFMapViewCameraDelegate {
    
    func mapView(_ mapView: NMFMapView, cameraWillChangeByReason reason: Int, animated: Bool) {
        if interactiveMapView.mode == .normal {
            interactiveMapView.removeAllFromTransparentLayer()
        }
        if reason < 0 {
            interactiveMapView.removePolygon()
        }
        placeListViewControllerDisAppear()
    }
    
    func mapView(_ mapView: NMFMapView, cameraIsChangingByReason reason: Int) {
        if interactiveMapView.mode == .normal {
            interactiveMapView.removeAllFromTransparentLayer()
        }
        placeListViewControllerDisAppear()
    }
    
    func mapView(_ mapView: NMFMapView, cameraDidChangeByReason reason: Int, animated: Bool) {
        if interactiveMapView.mode == .normal {
            interactiveMapView.removeAllFromTransparentLayer()
        }
        placeListViewControllerDisAppear()
    }
    
    func mapViewCameraIdle(_ mapView: NMFMapView) {
        if interactiveMapView.mode == .normal {
            interactiveMapView.removeAllFromTransparentLayer()
        }
        placeListViewControllerDisAppear()
    }
    
}
