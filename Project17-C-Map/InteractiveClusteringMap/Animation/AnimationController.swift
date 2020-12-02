//
//  AnimationLayerController.swift
//  InteractiveClusteringMap
//
//  Created by 박성민 on 2020/12/02.
//

import Foundation
import UIKit
import NMapsMap

class AnimationController {
    let transparentLayer = CALayer()
    var subLayer = CALayer()
    
    init(frame: CGRect, mapView: NMFMapView) {
        configure(frame: frame, mainView: mapView)
    }
    
    func configure(frame: CGRect, mainView: NMFMapView) {
        transparentLayer.bounds = frame
        transparentLayer.backgroundColor = CGColor(red: 100, green: 0, blue: 0, alpha: 0)
        transparentLayer.position = CGPoint(x: frame.width / 2, y: frame.height / 2)
        
        subLayer.bounds = CGRect(x: 0, y: 0, width: 50, height: 50)
        subLayer.cornerRadius = 25
        subLayer.backgroundColor = CGColor(red: 0.4, green: 0.5, blue: 0.1, alpha: 1)
        
        transparentLayer.addSublayer(subLayer)
        
        mainView.moveCamera(NMFCameraUpdate(scrollTo: NMGLatLng(lat: 37.45219245759162, lng: 126.65371209878728), zoomTo: 10))
       
        subLayer.position = mainView.projection.point(from: NMGLatLng(lat: 37.45219245759162, lng: 126.65371209878728))
        mainView.layer.addSublayer(transparentLayer)
    }
    
    
    
}
