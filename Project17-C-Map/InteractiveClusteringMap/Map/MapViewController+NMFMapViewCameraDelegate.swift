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
