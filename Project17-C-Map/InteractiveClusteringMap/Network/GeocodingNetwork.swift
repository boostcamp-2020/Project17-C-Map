//
//  APIService.swift
//  InteractiveClusteringMap
//
//  Created by Seungeon Kim on 2020/12/09.
//

import Foundation

enum NetworkError: Error {
    case url, author, param, unknown
    
    var localizedDescription: String {
        switch self {
        case .url:
            return "잘못된 주소 입니다."
        case .author:
            return "잘못된 인증키 입니다.."
        case .param:
            return "잘못된 파라미터 입니다."
        case .unknown:
            return "알 수 없는 에러입니다."
        }
    }
}

protocol Geocodable: class {
    
    func address(lat: Double, lng: Double, completion: @escaping ((Result<Data, Error>) -> Void))
    
}

final class GeocodingNetwork: Geocodable {
    
    func address(lat: Double, lng: Double, completion: @escaping ((Result<Data, Error>) -> Void)) {
        guard let url = URL(string: "\(Geocoding.url)" + "\(EndPoint.query(lat: lat, lng: lng))")
        else {
            defer {
                completion(.failure(NetworkError.url))
            }
            return
        }
        
        guard  let headerField = Header.get() else {
            defer {
                completion(.failure(NetworkError.author))
            }
            return
        }
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headerField
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                defer {
                    completion(.failure(error))
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  200...299 ~= httpResponse.statusCode else {
                defer {
                    completion(.failure(NetworkError.unknown))
                }
                return
            }
            
            guard let data = data else { return }
            
            completion(.success(data))
        }.resume()
    }
    
}

private extension GeocodingNetwork {
    
    enum Geocoding {
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
