//
//  APIService.swift
//  InteractiveClusteringMap
//
//  Created by Seungeon Kim on 2020/12/09.
//

import Foundation

protocol Geocodable: class {
    
    func address(lat: Double, lng: Double, completion: @escaping ((String) -> Void))
    
}

final class GeocodingNetwork: Geocodable {
    
    private let provider: DataProvided
    
    init(store: DataProvided) {
        self.provider = store
    }
    
    func address(lat: Double, lng: Double, completion: @escaping ((String) -> Void)) {
        let path: String = "\(GeocodingURL.url)" + "\(EndPoint.query(lat: lat, lng: lng))"
        
        provider.data(path: path, header: Header.get()) { result in
            switch result {
            case .success(let data):
                guard let data = data else { return }
                
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

private extension GeocodingNetwork {
    
    enum GeocodingURL {
        static let url = "https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc"
    }
    
    enum Header {
        static func get() -> [String: String]? {
            let clientKey = "NMFClientId"
            let secretKey = "NMFClientSecret"
            
            let clientKeyField = "X-NCP-APIGW-API-KEY-ID"
            let secretKeyFeild = "X-NCP-APIGW-API-KEY"
            
            guard let id = Bundle.main.infoDictionary?[clientKey] as? String,
                  let secret = Bundle.main.infoDictionary?[secretKey] as? String
            else {
                return nil
            }
            
            return [clientKeyField: id,
                    secretKeyFeild: secret]
        }
    }
    
    enum EndPoint {
        static func query(lat: Double, lng: Double) -> String {
            let addr: String = "roadaddr"
            let output: String = "json"
            return "?coords=\(lng),\(lat)&output=\(output)&orders=\(addr)"
        }
    }
    
}
