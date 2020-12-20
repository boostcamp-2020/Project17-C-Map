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
    private let serialQueue = DispatchQueue(label: "SerialQueue", qos: .utility)
    
    init(mapView: InteractiveMapView, interactor: ClusterBusinessLogic) {
        super.init()
        self.interactiveMapView = mapView
        self.interactor = interactor
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
              let removedTiles = removedTileIds as? [CLong],
              let interactiveMapView = interactiveMapView
        else {
            return
        }
        
        serialQueue.async { [weak self] in
            guard let self = self else { return }
            self.interactor?.remove(tileIds: removedTiles)
            var boundsWithTileId = [CLong: BoundingBox]()
            addedTiles.forEach { tileId in
                let bounds = NMFTileId.toLatLngBounds(fromTileId: tileId)
                boundsWithTileId[tileId] = bounds.makeBoundingBox()
            }
            self.interactor?.fetch(boundingBoxes: boundsWithTileId, zoomLevel: interactiveMapView.zoomLevel)
        }
    }
    
}

private extension MapController {
    
    enum QueueName {
        static let serial: String = "MapController.TileChangedEventQueue"
    }
    
}
