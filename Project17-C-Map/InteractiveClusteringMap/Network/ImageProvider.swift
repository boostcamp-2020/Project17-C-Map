//
//  ImageProvider.swift
//  StoreApp
//
//  Created by eunjeong lee on 2020/12/09.
//

import Foundation

protocol ImageProviding {
    func imageURL(from path: String, completion: @escaping (URL) -> Void)
}

struct ImageProvider: ImageProviding {
    
    private let concurrentQueue = DispatchQueue(label: Name.concurrentQueue,
                                                attributes: .concurrent)
    private let localStore: DataProvided
    private let httpStore: DataProvided
    
    init(localStore: DataProvided, httpStore: DataProvided) {
        self.localStore = localStore
        self.httpStore = httpStore
    }
    
    func imageURL(from path: String, completion: @escaping (URL) -> Void) {
        guard let fileName = path.fileName else { return }

        localStore.imageURL(path: fileName, completion: { url in
            guard let url = url,
                  FileManager.default.fileExists(atPath: url.path)
            else {
                return networkImageURL(from: path, completion: completion)
            }
            completion(url)
        })
    }
    
    private func networkImageURL(from path: String, completion: @escaping (URL) -> Void) {
        httpStore.imageURL(path: path) { networkURL in
            guard let networkURL = networkURL,
                  let fileName = path.fileName,
                  let url = networkURL.saveFileToCachesDirectory(fileName: fileName)
            else {
                return
            }
            DispatchQueue.main.async {
                completion(url)
            }
        }
    }
    
}

private extension String {
    
    var fileName: String? {
        self.components(separatedBy: "/").last
    }
    
}

private extension ImageProvider {
    
    enum Name {
        static let concurrentQueue = "ImageProvider.concurrentQueue"
    }
    
}
