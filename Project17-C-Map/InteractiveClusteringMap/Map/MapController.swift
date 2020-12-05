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
    private let serialQueue = DispatchQueue(label: QueueName.serial)
    
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
        guard let addedTiles = addedTileIds as? [CLong],
              let removedTiles = removedTileIds as? [CLong] else { return }

        serialQueue.async {
            self.interactor?.remove(tileIds: removedTiles)
            var boundsWithTileId = [CLong: BoundingBox]()
            addedTiles.forEach { tileId in
                let bounds = NMFTileId.toLatLngBounds(fromTileId: tileId)
                let BL = bounds.boundsLatLngs[Index.BL]
                let TR = bounds.boundsLatLngs[Index.TR]
                
                let bottomLeft = Coordinate(x: BL.lng, y: BL.lat)
                let topRight = Coordinate(x: TR.lng, y: TR.lat)
                boundsWithTileId[tileId] = BoundingBox(topRight: topRight, bottomLeft: bottomLeft)
            }
            
            guard let interactiveMapView = self.interactiveMapView else { return }
            self.interactor?.fetch(boundingBoxes: boundsWithTileId, zoomLevel: interactiveMapView.zoomLevel)
        }
    }
    
}

private extension MapController {
    
    enum Index {
        static let BL: Int = 0
        static let TR: Int = 1
    }
    
    enum QueueName {
        static let serial: String = "MapController.TileChangedEventQueue"
    }
    
}
