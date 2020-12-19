//
//  ViewController.swift
//  InteractiveClusteringMap
//
//  Created by Oh Donggeon on 2020/11/16.
//

import UIKit
import CoreLocation
import NMapsMap

final class MapViewController: UIViewController {
    
    @IBOutlet private(set) weak var interactiveMapView: InteractiveMapView!
    @IBOutlet private(set) weak var placeListButton: UIButton!
    @IBOutlet private weak var editModeLabel: UILabel!
    @IBOutlet private weak var playButton: UIButton!
    
    private let locationManager = CLLocationManager()
    private var mapController: MapController?
    private var dataManager: DataManagable?
    private(set) var presentedMarkers: [NMFMarker] = []
    private var pickedMarker: LeafNodeMarker?
    private let leafNodeMarkerInfoWindow = LeafNodeMarkerInfoWindow()
    private(set) var placeListViewController: PlaceListViewController?
    private var isTouchedRemove: Bool = false
    
    init?(coder: NSCoder, dataManager: DataManagable) {
        super.init(coder: coder)
        self.dataManager = dataManager
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization()
        dependencyInject()
        configureMap()
        bindingHandler()
        configurePlaceListViewController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !UserDefaultsManager.shared.isLaunched {
            presentOnboarding()
        }
    }
    
    private func configurePlaceListViewController() {
        guard let dataManager = dataManager,
              let placeListViewController = placeListViewController(dataManager: dataManager) else { return }
        
        self.placeListViewController = placeListViewController
        placeListViewController.didMove(toParent: self)
        addChild(placeListViewController)
        view.addSubview(placeListViewController.view)
    }
    
    private func presentOnboarding() {
        let onboardViewController = UIStoryboard(name: "Onboarding", bundle: nil).instantiateViewController(
            identifier: "OnboardingViewController",
            creator: { coder in
                return OnboardingViewController(coder: coder)
            })
        onboardViewController.modalPresentationStyle = .overFullScreen
        
        present(onboardViewController, animated: true)
    }
    
    private func dependencyInject() {
        guard let dataManager = dataManager else { return }
        
        let poiService = POIService(dataManager: dataManager)
        let treeDataStore = TreeDataStore(poiService: poiService)
        let presenter: ClusterPresentationLogic = MapPresenter(createMarkerHandler: create, removeMarkerHandler: remove)
        let mapInteractor: MapBusinessLogic = MapInteractor(treeDataStore: treeDataStore, presenter: presenter)
        mapController = MapController(mapView: interactiveMapView, interactor: mapInteractor)
    }
    
    private func configureMap() {
        interactiveMapView.mapView.addCameraDelegate(delegate: self)
        interactiveMapView?.mapView.touchDelegate = self
        interactiveMapView.configureGesture()
        editModeLabel.isHidden = true
        configurePlayButton()
    }
    
    private func configurePlayButton() {
        playButton.setImage(UIImage(systemName: "play.circle.fill")?.withTintColor(.blue), for: .normal)
        playButton.contentVerticalAlignment = .fill
        playButton.contentHorizontalAlignment = .fill
    }
    
    private func bindingHandler() {
        interactiveMapView.longTouchedMarkerHandler = longTouchedMarker
        interactiveMapView.showEditModeHandler = changeLeafNodeMarkerMode
        interactiveMapView.removeLeafMarkerHandler = removeLeafNode
    }
    
    private func longTouchedMarker(pressedMarker: NMFPickable?, latLng: NMGLatLng) {
        if pressedMarker is LeafNodeMarker {
            interactiveMapView.mode = .edit
            editModeLabel.isHidden = false
            playButton.isEnabled = false
            return
        }
        
        if let clusterMarker = pressedMarker as? ClusteringMarker {
            interactiveMapView.drawPolygon(boundingBox: clusterMarker.boundingBox)
            return
        }
        
        addLeafNodeMarker(latlng: latLng)
    }
    
    private func addLeafNodeMarker(latlng: NMGLatLng) {
        if interactiveMapView.zoomLevel > 15 {
        
        let alert = MapAlertControllerFactory.createAddAlertController { [weak self] text in
            guard let self = self else { return }
            
            let poi = POI(x: latlng.lng, y: latlng.lat, name: text, category: Name.categoty)
            self.mapController?.add(poi: poi)
        }
        
        present(alert, animated: true)
            
        } else {
            showToast(message: Name.toastMessage)
        }
    }
    
    private func changeLeafNodeMarkerMode(layer: TransparentLayer) {
        presentedMarkers.forEach { marker in
            guard let marker = marker as? LeafNodeMarker else { return }
            marker.hidden = true
            marker.createMarkerLayer()
            guard let leafNodeMarkerLayer = marker.markerLayer else { return }
            leafNodeMarkerLayer.bounds = CGRect(x: 0, y: 0,
                                                width: marker.iconImage.imageWidth,
                                                height: marker.iconImage.imageHeight)
            leafNodeMarkerLayer.contents = marker.iconImage.image.cgImage
            leafNodeMarkerLayer.addEditButtonLayer()
            layer.addSublayer(leafNodeMarkerLayer)
            
            guard let position = marker.mapView?.projection.point(from: NMGLatLng(lat: marker.coordinate.y, lng: marker.coordinate.x))
            else {
                return
            }
            
            leafNodeMarkerLayer.position = position
            leafNodeMarkerLayer.editButtonLayer.position = CGPoint(x: 8, y: 8)
            leafNodeMarkerLayer.animate()
        }
    }
    
    private func removeLeafNode(point: CGPoint) {
        for (index, marker) in presentedMarkers.enumerated() {
            guard let leafNodeMarker = marker as? LeafNodeMarker,
                  leafNodeMarker.containsMarker(at: point) else { continue }
            
            isTouchedRemove = true
            let alert = MapAlertControllerFactory.createDeleteAlertController { [weak self] _ in
                guard let self = self else { return }
                
                leafNodeMarker.mapView = nil
                leafNodeMarker.markerLayer?.removeFromSuperlayer()
                leafNodeMarker.touchHandler = nil
                self.presentedMarkers.remove(at: index)
                self.mapController?.delete(coordinate: leafNodeMarker.coordinate)
                self.isTouchedRemove = false
            }
            present(alert, animated: true)
        }
    }
    
    private func create(markers: [NMFMarker]) {
        markers.forEach { marker in
            marker.mapView = self.interactiveMapView.mapView
            marker.hidden = true
            self.presentedMarkers.append(marker)
            
            if let leafNodeMarker = marker as? LeafNodeMarker {
                leafNodeMarker.createMarkerLayer()
                self.animate(marker: leafNodeMarker)

                leafNodeMarker.touchHandler = { [weak self] (_) -> Bool in
                    guard let self = self else { return false }

                    let userInfo = self.mapController?.fetchInfo(by: leafNodeMarker.coordinate)
                    leafNodeMarker.configureUserInfo(userInfo: userInfo)

                    self.pickedMarker?.resizeMarkerSize()
                    leafNodeMarker.sizeUp()
                    self.pickedMarker = leafNodeMarker
                    self.leafNodeMarkerInfoWindow.open(with: leafNodeMarker)
                    return true
                }
                
            } else if let clusteringMarker = marker as? ClusteringMarker {
                self.setMarkersHandler(marker: clusteringMarker)
                self.animate(marker: clusteringMarker)
            }
        }
        updatePlaceListViewController()
    }
    
    private func remove(markers: [NMFMarker]) {
        markers.forEach { marker in
            marker.mapView = nil
            self.presentedMarkers.removeAll { $0 == marker }
            marker.touchHandler = nil
        }
    }
    
    private func animate(marker: NMFMarker) {
        var markerLayer: CALayer?
        var markerPosition: CGPoint?
        
        if let leafNodeMarker = marker as? LeafNodeMarker {
            markerLayer = leafNodeMarker.markerLayer
            markerPosition = leafNodeMarker.mapView?.project(from: NMGLatLng(lat: leafNodeMarker.coordinate.y,
                                                                             lng: leafNodeMarker.coordinate.x))
            
        } else if let clusteringMarker = marker as? ClusteringMarker {
            markerLayer = clusteringMarker.markerLayer
            markerPosition = clusteringMarker.mapView?.project(from: NMGLatLng(lat: clusteringMarker.coordinate.y,
                                                                               lng: clusteringMarker.coordinate.x))
        }
        guard let layer = markerLayer,
              let position = markerPosition else { return }
        
        interactiveMapView.addToTransparentLayer(layer)
        marker.animate(position: position)
    }
    
    private func setMarkersHandler(marker: ClusteringMarker) {
        marker.touchHandler = { [weak self] _ in
            guard let self = self,
                  self.interactiveMapView.mode != .edit else { return true }
            
            self.interactiveMapView.drawPolygon(boundingBox: marker.boundingBox)
            self.interactiveMapView.moveCamera(position: marker.position,
                                               boundingBox: marker.boundingBox,
                                               count: marker.coordinatesCount)
            let markerLayer = marker.markerLayer
            
            guard let position = marker.mapView?.project(from: NMGLatLng(
                                                            lat: marker.coordinate.y,
                                                            lng: marker.coordinate.x))
            else {
                return false
            }
            
            markerLayer.position = position
            let markerAnimation = AnimationController.zoomTouchAnimation()
            markerLayer.opacity = 0
            self.interactiveMapView.addToTransparentLayer(markerLayer)
            
            CATransaction.begin()
            marker.hidden = true
            CATransaction.setCompletionBlock {
                markerLayer.removeFromSuperlayer()
            }
            markerLayer.add(markerAnimation, forKey: "dismissMarker")
            CATransaction.commit()
            
            return true
        }
    }

    @IBAction private func touchedPlayButton(_ sender: UIButton) {
        interactiveMapView.playCameraAnimation()
    }
    
}

extension MapViewController: NMFMapViewTouchDelegate {
    
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        guard isTouchedRemove == false else { return }
        
        leafNodeMarkerInfoWindow.close()
        interactiveMapView.mode = .normal
        editModeLabel.isHidden = true
        playButton.isEnabled = true
        
        presentedMarkers.forEach {
            $0.hidden = false
        }
        
        pickedMarker?.resizeMarkerSize()
    }
    
}

private extension MapViewController {
    
    enum Name {
        static let toastMessage = " 마커를 추가하려면 지도를 확대해주세요 "
        static let categoty = "기타"
    }
    
}
