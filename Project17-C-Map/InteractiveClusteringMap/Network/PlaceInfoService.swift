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
        geocodingNetwork.address(lat: lat, lng: lng) { result in
            switch result {
            case .success(let data):
                let decoder = JSONDecoder()
                let result = try? decoder.decode(Geocoding.self, from: data)
                DispatchQueue.main.async {
                    completion(result?.description ?? "")
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(error.localizedDescription)
                }
            }
        }
    }
    
}
