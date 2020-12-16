//
//  MapViewController+NMFMapViewCameraDelegate.swift
//  InteractiveClusteringMap
//
//  Created by 박성민 on 2020/12/16.
//

import NMapsMap

extension MapViewController: NMFMapViewCameraDelegate {
    func mapView(_ mapView: NMFMapView, cameraWillChangeByReason reason: Int, animated: Bool) {
        if !isEditMode {
            interactiveMapView.removeAllFromTransparentLayer()
        }
    }
    
    func mapView(_ mapView: NMFMapView, cameraIsChangingByReason reason: Int) {
        if !isEditMode {
            interactiveMapView.removeAllFromTransparentLayer()
        }
    }
    
    func mapView(_ mapView: NMFMapView, cameraDidChangeByReason reason: Int, animated: Bool) {
        if !isEditMode {
            interactiveMapView.removeAllFromTransparentLayer()
        }
    }
    
    func mapViewCameraIdle(_ mapView: NMFMapView) {
        if !isEditMode {
            interactiveMapView.removeAllFromTransparentLayer()
        }
    }
}

