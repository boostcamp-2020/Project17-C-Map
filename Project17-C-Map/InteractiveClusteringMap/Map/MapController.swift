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
        super.init()
        self.interactiveMapView = mapView
        self.interactor = interactor
        configureTileCoverHelper()
    }
    
    func add(coordinate: Coordinate) {
        guard let tileIds = interactiveMapView?.mapView.getCoveringTileIds() as? [CLong] else { return }
        
        for tileId in tileIds {
            let bounds = NMFTileId.toLatLngBounds(fromTileId: tileId)
            let boundingBox = bounds.makeBoundingBox()
            if boundingBox.contains(coordinate: coordinate) {
                interactor?.add(tileId: tileId, coordinate: coordinate)
                break
            }
        }
    }
    
    func delete(coordinate: Coordinate) {
        interactor?.remove(coordinate: coordinate)
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

        interactor?.remove(tileIds: removedTiles)
        var boundsWithTileId = [CLong: BoundingBox]()
        addedTiles.forEach { tileId in
            let bounds = NMFTileId.toLatLngBounds(fromTileId: tileId)
            boundsWithTileId[tileId] = bounds.makeBoundingBox()
        }
        interactor?.fetch(boundingBoxes: boundsWithTileId, zoomLevel: interactiveMapView.zoomLevel)
    }
    
}

private extension MapController {
    
    enum QueueName {
        static let serial: String = "MapController.TileChangedEventQueue"
    }
    
}

enum Index {
    static let BL: Int = 0
    static let TR: Int = 1
}

extension NMGLatLngBounds {
    
    func makeBoundingBox() -> BoundingBox {
        let BL = self.boundsLatLngs[Index.BL]
        let TR = self.boundsLatLngs[Index.TR]
        
        let bottomLeft = Coordinate(x: BL.lng, y: BL.lat)
        let topRight = Coordinate(x: TR.lng, y: TR.lat)
        
        return BoundingBox(topRight: topRight, bottomLeft: bottomLeft)
    }
    
}
