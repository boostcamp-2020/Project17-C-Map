//
//  FileManager+Duplicate.swift
//  InteractiveClusteringMap
//
//  Created by eunjeong lee on 2020/12/09.
//

import Foundation

extension FileManager {
    
    func deleteDuplicates(at url: URL) {
        if fileExists(atPath: url.path) {
            try? removeItem(at: url)
        }
    }
    
    func cacheDirectory() -> URL? {
        try? FileManager.default.url(for: .cachesDirectory,
                                     in: .userDomainMask,
                                     appropriateFor: nil,
                                     create: false)
    }
    
}
