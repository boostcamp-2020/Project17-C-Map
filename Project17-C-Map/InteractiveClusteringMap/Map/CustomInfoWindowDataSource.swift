//
//  CustomInfoWindowDataSource.swift
//  InteractiveClusteringMap
//
//  Created by A on 2020/12/08.
//

import UIKit
import NMapsMap

class CustomInfoWindowDataSource: NSObject, NMFOverlayImageDataSource {
    
    enum Name {
        static let title = "title"
        static let category = "category"
    }
    
    func view(with overlay: NMFOverlay) -> UIView {
        let rootView = CustomInfoWindowView()
        rootView.configureNib()
        
        guard let infoWindow = overlay as? NMFInfoWindow,
              infoWindow.marker != nil else { return rootView }
        infoWindow.offsetX = -136
        let title = infoWindow.marker?.userInfo["title"] as? String ?? "성주"
        let category = infoWindow.marker?.userInfo["category"] as? String ?? "은정"
        
        rootView.configureContent(title: title, category: category)
        
        return rootView
    }
}
