//
//  DataManager.swift
//  DataManager
//
//  Created by eunjeong lee on 2020/10/16.
//

import UIKit

protocol DataProvided {
    func data(path: String, completion: @escaping (Data?) -> Void)
    func imageURL(path: String, completion: @escaping (URL?) -> Void)
}

struct LocalDataProvider: DataProvided {
    
    static let shared = LocalDataProvider()

    private init() {}
    
    private let concurrentQueue = DispatchQueue(label: Name.dataProviderConcurrentQueue,
                                                       qos: .utility,
                                                       attributes: .concurrent)
    
    func data(path: String, completion: @escaping (Data?) -> Void) {
        concurrentQueue.async {
            guard let file = Bundle.main.url(forResource: path,
                                             withExtension: Name.jsonType)
            else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            DispatchQueue.main.async {
                completion(try? Data(contentsOf: file))
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

private enum Name {
    static let jsonType: String = "json"
    static let dataProviderConcurrentQueue = "DataProviderConcurrentQueue"
}
