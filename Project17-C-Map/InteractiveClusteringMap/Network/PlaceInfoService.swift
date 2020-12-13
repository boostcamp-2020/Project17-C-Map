//
//  PlaceInfoService.swift
//  InteractiveClusteringMap
//
//  Created by Seungeon Kim on 2020/12/10.
//

import UIKit

protocol PlaceInfoServicing: class {
    func fetchImage(url: String, completion: @escaping (UIImage?) -> Void)
    func fetchAdrress(lat: Double, lng: Double, completion: @escaping (String) -> Void)
}

final class PlaceInfoService: PlaceInfoServicing {
    private let imageProvider: ImageProviding
    private let geocodingNetwork: Geocodable
    private var repositroy: [Coordinate: String] = [: ]
    
    init(imageProvider: ImageProviding, geocodingNetwork: Geocodable) {
        self.imageProvider = imageProvider
        self.geocodingNetwork = geocodingNetwork
    }
    
    func fetchImage(url: String, completion: @escaping (UIImage?) -> Void) {
        imageProvider.imageURL(from: url) { url in
            let image = UIImage(contentsOfFile: url.path)
            completion(image)
        }
    }
    
    func fetchAdrress(lat: Double, lng: Double, completion: @escaping (String) -> Void) {
        let coordinate = Coordinate(x: lng, y: lat)
       
        guard let address = repositroy[coordinate] else {
            geocodingNetwork.address(lat: lat, lng: lng) { [weak self] result in
                guard let self = self else { return }
                self.repositroy[coordinate] = result
                completion(result)
            }
            return
        }
        completion(address)
    }
    
}
