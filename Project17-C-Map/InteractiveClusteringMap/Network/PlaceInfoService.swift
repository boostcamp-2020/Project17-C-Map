//
//  PlaceInfoService.swift
//  InteractiveClusteringMap
//
//  Created by Seungeon Kim on 2020/12/10.
//

import UIKit

protocol PlaceInfoServicing: class {
    
    func fetchImage(url: String, completion: @escaping (UIImage?) -> Void)
    func fetchAddress(lat: Double, lng: Double, completion: @escaping (String) -> Void)
    func cancel()
    
}

final class PlaceInfoService: PlaceInfoServicing {
    
    private let imageOperationQueue = OperationQueue()
    private let addressOperationQueue = OperationQueue()
    private let imageProvider: ImageProviding
    private let geocodingNetwork: Geocodable
    private var repositroy: [Coordinate: String] = [: ]
    
    init(imageProvider: ImageProviding, geocodingNetwork: Geocodable) {
        self.imageProvider = imageProvider
        self.geocodingNetwork = geocodingNetwork
    }
    
    func fetchImage(url: String, completion: @escaping (UIImage?) -> Void) {
        let operation = BlockOperation()
        operation.addExecutionBlock { [weak self] in
            guard let self = self else { return }
            if operation.isCancelled { return }
            
            self.imageProvider.imageURL(from: url) { url in
                if operation.isCancelled { return }
                
                let image = UIImage(contentsOfFile: url.path)
                completion(image)
            }
        }
        imageOperationQueue.addOperation(operation)
    }
    
    func fetchAddress(lat: Double, lng: Double, completion: @escaping (String) -> Void) {
        let operation = BlockOperation()
        operation.addExecutionBlock { [weak self] in
            guard let self = self else { return }
            if operation.isCancelled { return }
            
            let coordinate = Coordinate(x: lng, y: lat)
           
            guard let address = self.repositroy[coordinate] else {
                self.geocodingNetwork.address(lat: lat, lng: lng) { [weak self] result in
                    guard let self = self else { return }
                    if operation.isCancelled { return }

                    self.repositroy[coordinate] = result
                    completion(result)
                }
                return
            }
            completion(address)
        }
        addressOperationQueue.addOperation(operation)
    }
    
    func cancel() {
        imageOperationQueue.cancelAllOperations()
        addressOperationQueue.cancelAllOperations()
    }
    
}
