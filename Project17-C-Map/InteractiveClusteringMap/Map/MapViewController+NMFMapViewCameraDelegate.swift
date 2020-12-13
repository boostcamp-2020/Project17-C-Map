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
        transparentLayer?.sublayers?.forEach { sublayer in
            sublayer.removeAllAnimations()
            sublayer.removeFromSuperlayer()
            
        }
    }
    
    func mapView(_ mapView: NMFMapView, cameraDidChangeByReason reason: Int, animated: Bool) {
        transparentLayer?.sublayers?.forEach { sublayer in
            sublayer.removeAllAnimations()
            sublayer.removeFromSuperlayer()
           
        }
    }
    
    func mapView(_ mapView: NMFMapView, cameraWillChangeByReason reason: Int, animated: Bool) {
        transparentLayer?.sublayers?.forEach { sublayer in
            sublayer.removeAllAnimations()
            sublayer.removeFromSuperlayer()
            
        }
    }
    
    func mapViewCameraIdle(_ mapView: NMFMapView) {
        transparentLayer?.sublayers?.forEach { sublayer in
            sublayer.removeAllAnimations()
            sublayer.removeFromSuperlayer()
            
        }
    }
}
