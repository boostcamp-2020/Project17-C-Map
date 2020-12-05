//
//  MapViewController+NMFMapViewCameraDelegate.swift
//  InteractiveClusteringMap
//
//  Created by 박성민 on 2020/12/03.
//

import Foundation
import NMapsMap

extension MapViewController: NMFMapViewCameraDelegate {
    func mapView(_ mapView: NMFMapView, cameraIsChangingByReason reason: Int) {
        self.transparentLayer?.sublayers?.forEach { subLayer in
            self.setMarkerPosition(marker: subLayer)
        }
    }
    
    func mapView(_ mapView: NMFMapView, cameraWillChangeByReason reason: Int, animated: Bool) {
        self.transparentLayer?.sublayers?.forEach { subLayer in
            self.setMarkerPosition(marker: subLayer)
            infoWindowForAdd.close()
        }
    }
    
    func mapView(_ mapView: NMFMapView, cameraDidChangeByReason reason: Int, animated: Bool) {
        self.transparentLayer?.sublayers?.forEach { subLayer in
            self.setMarkerPosition(marker: subLayer)
        }
    }
    
    func mapViewCameraIdle(_ mapView: NMFMapView) {
        self.transparentLayer?.sublayers?.forEach { subLayer in
            self.setMarkerPosition(marker: subLayer)
        }
    }
}
