//
//  MapController.swift
//  InteractiveClusteringMap
//
//  Created by 박성민 on 2020/11/21.
//

import Foundation
import NMapsMap

final class MapController: NSObject {
    
    private var tileCoverHelper: NMFTileCoverHelper?
    private var interactor: ClusterBusinessLogic?
    private weak var interactiveMapView: InteractiveMapView?
    
    init(mapView: InteractiveMapView, interactor: ClusterBusinessLogic) {
        self.interactiveMapView = mapView
        self.interactor = interactor
        super.init()
        configureTileCoverHelper()
    }
    
    private func configureTileCoverHelper() {
        guard let interactiveMapView = interactiveMapView else { return }
        
        tileCoverHelper = NMFTileCoverHelper(interactiveMapView.mapView)
        tileCoverHelper?.delegate = self
    }
    
}

extension MapController: NMFTileCoverHelperDelegate {
    
    func onTileChanged(_ addedTileIds: [NSNumber]?, removedTileIds: [NSNumber]?) {
        guard let addedTiles = addedTileIds as? [CLong] else { return }
        
        let bounds = addedTiles.map { tileId -> BoundingBox in
            let bounds = NMFTileId.toLatLngBounds(fromTileId: tileId)
            let BL = bounds.boundsLatLngs[Index.BL]
            let TR = bounds.boundsLatLngs[Index.TR]
            
            let bottomLeft = Coordinate(x: BL.lng, y: BL.lat)
            let topRight = Coordinate(x: TR.lng, y: TR.lat)
        
            return BoundingBox(topRight: topRight, bottomLeft: bottomLeft)
        }
        guard let interactiveMapView = interactiveMapView else { return }
        interactor?.fetch(boundingBoxes: bounds, zoomLevel: interactiveMapView.zoomLevel)
    }
    
}

private extension MapController {
    
    enum Index {
        static let BL: Int = 0
        static let TR: Int = 1
    }
    
}