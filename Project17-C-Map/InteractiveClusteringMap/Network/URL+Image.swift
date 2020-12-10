//
//  URL+Image.swift
//  InteractiveClusteringMap
//
//  Created by eunjeong lee on 2020/12/09.
//

import Foundation

extension URL {
    
    func saveFileToCachesDirectory(fileName: String) -> URL? {
        guard let cacheDirectory = FileManager.default.cacheDirectory()
        else {
            return nil
        }
        let fileURL = cacheDirectory.appendingPathComponent(fileName)
        FileManager.default.deleteDuplicates(at: fileURL)
        try? FileManager.default.moveItem(atPath: self.path,
                                          toPath: fileURL.path)
        return fileURL
    }

}
