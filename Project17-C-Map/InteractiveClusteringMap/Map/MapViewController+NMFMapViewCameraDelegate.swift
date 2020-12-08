//
//  MapViewController+NMFMapViewCameraDelegate.swift
//  InteractiveClusteringMap
//
//  Created by 박성민 on 2020/12/03.
//

import Foundation
import NMapsMap

extension MapViewController: NMFMapViewCameraDelegate {
    
    func mapView(_ mapView: NMFMapView, cameraWillChangeByReason reason: Int, animated: Bool) {
        self.transparentLayer?.sublayers?.forEach { sublayer in
            guard !isEditMode else { return }
            sublayer.removeAllAnimations()
            sublayer.removeFromSuperlayer()
        }
    }
}
