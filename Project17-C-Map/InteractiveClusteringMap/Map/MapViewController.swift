//
//  ViewController.swift
//  InteractiveClusteringMap
//
//  Created by Oh Donggeon on 2020/11/16.
//

import UIKit
import CoreLocation
import NMapsMap

// 다음 PR에 Tree 객체 저장하고 불러오는 기능 프로토콜 추가 예정
protocol TreeServicing {
    
}

struct MockTreeService: TreeServicing {
    
}

final class MapViewController: UIViewController {
    @IBOutlet private weak var interactiveMapView: InteractiveMapView!
    private let locationManager = CLLocationManager()
    private var mapController: MapController?
    private var dataManager: DataManagable?
    internal var transparentLayer: TransparentLayer?
    private var deletedinteractiveMarkers: [Markerable] = []
    
    init?(coder: NSCoder, dataManager: DataManagable) {
        self.dataManager = dataManager
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization()
        dependencyInject()
        configureMap()
    }
    
    private func dependencyInject() {
        guard let dataManager = dataManager else { return }
        
        let poiService = POIService(dataManager: dataManager)
        let treeService = MockTreeService()
        let treeDataStore = TreeDataStore(poiService: poiService, treeService: treeService)
        
        let presenter: ClusterPresentationLogic = MapPresenter(createMarkerHandler: create, removeMarkerHandler: remove)
        let mapInteractor: ClusterBusinessLogic = MapInteractor(treeDataStore: treeDataStore, presenter: presenter)
        mapController = MapController(mapView: interactiveMapView, interactor: mapInteractor)
    }
    
    private func configureMap() {
        interactiveMapView.mapView.moveCamera(NMFCameraUpdate(scrollTo: NMGLatLng(lat: 37.56825785, lng: 126.9930027), zoomTo: 15))
        
        let coords1 = [NMGLatLng(lat: 37.5764792, lng: 126.9956437),
                       NMGLatLng(lat: 37.5600365, lng: 126.9956437),
                       NMGLatLng(lat: 37.5600365, lng: 126.9903617),
                       NMGLatLng(lat: 37.5764792, lng: 126.9903617),
                       NMGLatLng(lat: 37.5764792, lng: 126.9956437)]
        
        let polygon = NMGPolygon(ring: NMGLineString(points: coords1)) as NMGPolygon<AnyObject>
        let polygonOverlay = NMFPolygonOverlay(polygon)
        polygonOverlay?.fillColor = UIColor(red: 25.0/255.0, green: 192.0/255.0, blue: 46.0/255.0, alpha: 31.0/255.0)
        polygonOverlay?.outlineWidth = 3
        polygonOverlay?.mapView = interactiveMapView.mapView
        
        interactiveMapView.mapView.addCameraDelegate(delegate: self)
        
        transparentLayer = TransparentLayer(bounds: view.bounds)
        guard let transparentLayer = transparentLayer else { return }
        
        interactiveMapView.mapView.layer.addSublayer(transparentLayer)
    }
    
    internal func setMarkerPosition(marker: CALayer) {
        guard let marker = marker as? ClusteringMarkerLayer else { return }
        
        let latLng = NMGLatLng(lat: marker.center.y, lng: marker.center.x)
        marker.updatePosition(position: interactiveMapView.projectPoint(from: latLng))
    }
    
    private func create(markers: [Markerable]) {
        remove(markers: deletedinteractiveMarkers)
        
        markers.forEach { marker in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                if let clusteringMarkerLayer = marker as? ClusteringMarkerLayer {
                    self.setMarkerPosition(marker: clusteringMarkerLayer)
                    
                    let animation = AnimationController.fadeInOut(option: .fadeIn)
                    clusteringMarkerLayer.add(animation, forKey: "fadeIn")
                    
                    self.transparentLayer?.addSublayer(clusteringMarkerLayer)
                } else if let interactiveMaker = marker as? InteractiveMarker {
                    interactiveMaker.mapView = self.interactiveMapView.mapView
                }
            }
        }
    }
    
    private func addToDelete(markers: [Markerable]) {
        deletedinteractiveMarkers += markers
    }
    
    private func remove(markers: [Markerable]) {
        markers.forEach { marker in
            DispatchQueue.main.async {
                if let clusteringMarkerLayer = marker as? ClusteringMarkerLayer {
                    let animation = AnimationController.fadeInOut(option: .fadeOut)
                    
                    clusteringMarkerLayer.add(animation, forKey: "fadeOut")
                    DispatchQueue.main.asyncAfter(deadline: .now() + animation.duration - 0.4) {
                        clusteringMarkerLayer.remove()
                        self.deletedinteractiveMarkers.removeAll { deletedMarker in
                            guard let deletedMarker = deletedMarker as? ClusteringMarkerLayer else { return false }
                                return deletedMarker == clusteringMarkerLayer
                        }
                    }
                } else if let interactiveMaker = marker as? InteractiveMarker {
                    interactiveMaker.remove()
                    self.deletedinteractiveMarkers.removeAll { deletedMarker in
                        guard let deletedMarker = deletedMarker as? InteractiveMarker else { return false }
                            return deletedMarker == interactiveMaker
                    }
                }
            }
        }
    }
    
}
