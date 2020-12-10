//
//  DataManager.swift
//  DataManager
//
//  Created by eunjeong lee on 2020/10/16.
//

import Foundation

enum Store {
    case local
    case http
    
    var dataProvider: DataProvided {
        switch self {
        case .local:
            return LocalDataProvider.shared
        case .http:
            return HTTPDataProvider.shared
        }
    }
}

protocol DataProvided {
    func data(path: String, header: [String: String]?, completion: @escaping (Result<Data?, Error>) -> Void)
    func imageURL(path: String, completion: @escaping (URL?) -> Void)
}

struct LocalDataProvider: DataProvided {
    
    static let shared = LocalDataProvider()

    private init() {}
    
    private let concurrentQueue = DispatchQueue(label: Name.dataProviderConcurrentQueue,
                                                       qos: .utility,
                                                       attributes: .concurrent)
    
    func data(path: String, header: [String: String]?, completion: @escaping (Result<Data?, Error>) -> Void) {
        concurrentQueue.async {
            guard let file = Bundle.main.url(forResource: path,
                                             withExtension: Name.jsonType)
            else {
                DispatchQueue.main.async {
                    completion(.failure(LocalError.notFoundFile))
                }
                return
            }
            
            DispatchQueue.main.async {
                completion(.success(try? Data(contentsOf: file)))
            }
        }
    }
    
    func imageURL(path: String, completion: @escaping (URL?) -> Void) {
        concurrentQueue.async {
            guard let cacheDirectory = FileManager.default.cacheDirectory()
            else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            let url = cacheDirectory.absoluteURL.appendingPathComponent(path)
            DispatchQueue.main.async {
                completion(url)
            }
        }
        
    }
}

struct HTTPDataProvider: DataProvided {
    
    static let shared = HTTPDataProvider()

    private init() {}
    
    private let session = URLSession(configuration: .default)
    private let concurrentQueue = DispatchQueue(label: Name.dataProviderConcurrentQueue,
                                                       qos: .utility,
                                                       attributes: .concurrent)
    
    func data(path: String, header: [String: String]?, completion: @escaping (Result<Data?, Error>) -> Void) {
        guard let url = URL(string: path)
        else {
            defer {
                completion(.failure(NetworkError.url))
            }
            return
        }
        
        guard let header = header else {
            defer {
                completion(.failure(NetworkError.author))
            }
            return
        }
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = header
        
        concurrentQueue.async {
            session.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    return completion(.failure(error))
                }
                
                guard let httpResponse = response as? HTTPURLResponse,
                      200...299 ~= httpResponse.statusCode
                else {
                    return completion(.failure(NetworkError.unknown))
                }
                
                completion(.success(data))
            }.resume()
        }
    }
    
    func imageURL(path: String, completion: @escaping (URL?) -> Void) {
        guard let base = URL(string: path)
        else {
            return completion(nil)
        }
        
        concurrentQueue.async {
            URLSession.shared.downloadTask(with: base) { (url, _, _) in
                completion(url)
            }.resume()
        }
    }

}

private enum Name {
    static let jsonType: String = "json"
    static let dataProviderConcurrentQueue = "DataProviderConcurrentQueue"
}
