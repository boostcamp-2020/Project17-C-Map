//
//  CustomInfoWindowDataSource.swift
//  InteractiveClusteringMap
//
//  Created by A on 2020/12/08.
//

import UIKit
import NMapsMap

class CustomInfoWindowDataSource: NSObject, NMFOverlayImageDataSource {
    
    func view(with overlay: NMFOverlay) -> UIView {
        let rootView = Bundle.main.loadNibNamed("CustomInfoWindowView", owner: nil, options: nil)?.first as? CustomInfoWindowView ?? CustomInfoWindowView()
        
        guard let infoWindow = overlay as? NMFInfoWindow else { return rootView }
        
        guard infoWindow.marker != nil else { return rootView }
        
        rootView.titleLabel.text = infoWindow.marker?.userInfo["title"] as? String
        rootView.categoryLabel.text = infoWindow.marker?.userInfo["category"] as? String
        rootView.titleLabel.sizeToFit()
        rootView.categoryLabel.sizeToFit()
        let width = rootView.titleLabel.frame.size.width + rootView.categoryLabel.frame.size.width + 10
        rootView.frame = CGRect(x: 0, y: 0, width: width, height: 88)
        rootView.layoutIfNeeded()
        
        return rootView
    }
}
