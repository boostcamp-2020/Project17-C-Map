//
//  MapViewController+PlaceListView.swift
//  InteractiveClusteringMap
//
//  Created by eunjeong lee on 2020/12/19.
//

import UIKit
import NMapsMap

// MARK: - placeListButton event
extension MapViewController {
    
    private func markersToCoordinates(_ markers: [NMFMarker]) -> [Coordinate] {
        let clusters: [[Coordinate]] = markers.compactMap {
            if let marker = $0 as? ClusteringMarker {
                return marker.cluster.coordinates
            }
            
            if let marker = $0 as? LeafNodeMarker {
                return [marker.coordinate]
            }
            
            return nil
        }
        return clusters.flatMap { $0 }
    }
    
    @IBAction private func placeListButtonTouched(_ sender: UIButton) {
        placeListButtonDisappearAnimation()
        placeListViewController?.appearAnimation()
        
        let coordinates: [Coordinate] = markersToCoordinates(presentedMarkers)
        let cluster = Cluster(coordinates: coordinates, boundingBox: .korea)
        placeListViewController?.requestPlaces(cluster: cluster)
    }
    
    func updatePlaceListViewController() {
        let coordinates: [Coordinate] = markersToCoordinates(presentedMarkers)
        guard let placeListViewController = placeListViewController else { return }
        
        if coordinates.count < 100 {
            if placeListButton.isHidden && placeListViewController.isShow == false {
                placeListButtonDisplayed(true)
            } else if placeListButton.isHidden {
                let cluster = Cluster(coordinates: coordinates, boundingBox: .korea)
                placeListViewController.requestPlaces(cluster: cluster)
            }
        } else {
            placeListButtonDisplayed(false)
            placeListViewController.disappear()
        }
    }
    
    func placeListViewControllerDisappear() {
        if placeListViewController?.isShow ?? false {
            placeListButtonDisplayed(true)
            placeListViewController?.disappear()
            placeListViewController?.cancelAllOperation()
        }
    }
    
    private func placeListButtonDisplayed(_ displayed: Bool) {
        placeListButton.isHidden = !displayed
        placeListButton.layer.isHidden = !displayed
        placeListButton.layer.opacity = !displayed ? 0 : 1
    }

    private func placeListButtonDisappearAnimation() {
        guard !placeListButton.isHidden else { return }
        
        CATransaction.begin()
        placeListButton.layer.opacity = 0
        CATransaction.setCompletionBlock { [weak self] in
            self?.placeListButtonDisplayed(false)
        }
        let animation = AnimationController.floatingButtonAnimation(option: .disapper)
        placeListButton.layer.add(animation, forKey: "floatingButtonDisappearAnimation")
        CATransaction.commit()
    }
    
    private func placeListButtonAppearAnimation() {
        guard placeListButton.isHidden else { return }
        
        CATransaction.begin()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            self?.placeListButtonDisplayed(true)
        }
        let animation = AnimationController.floatingButtonAnimation(option: .appear)
        placeListButton.layer.add(animation, forKey: "floatingButtonAppearAnimation")
        CATransaction.commit()
    }
    
}

// MARK: - PlaceListViewController configure
extension MapViewController {
    
    func placeListViewController(dataManager: DataManagable) -> PlaceListViewController? {
        let poiService = POIService(dataManager: dataManager)
        let geo = GeocodingNetwork(store: Store.http.dataProvider)
        let img = ImageProvider(localStore: Store.local.dataProvider, httpStore: Store.http.dataProvider)
        let service = PlaceInfoService(imageProvider: img, geocodingNetwork: geo)
                
        guard let placeListViewController = PlaceListViewController.storyboardInstance(poiService: poiService,
                                                                                       placeInfoService: service)
        else {
            return nil
        }
        placeListViewController.cancelButtonTouchedHandler = placeListButtonAppearAnimation
        placeListViewController.delegate = self
        return placeListViewController
    }
    
}

extension MapViewController: PlaceListViewControllerDelegate {
    
    func selectedPlace(_ placeListViewController: PlaceListViewController, place: Place) {
        let lat = place.coordinate.y
        let lng = place.coordinate.x
        let zoom: Double = interactiveMapView.mapView.maxZoomLevel
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: lat, lng: lng), zoomTo: zoom)
        cameraUpdate.animation = .fly
        interactiveMapView.mapView.moveCamera(cameraUpdate)
        placeListViewController.minimumHeightMode()
    }
    
}
