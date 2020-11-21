//
//  JSONReader.swift
//  InteractiveClusteringMap
//
//  Created by Oh Donggeon on 2020/11/21.
//

import Foundation

class JSONReader {
    
    private func readJSON(from fileName: String) -> Data? {
        do {
            if let bundlePath = Bundle.main.path(forResource: fileName, ofType: "json"),
               let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                return jsonData
            }
        } catch {
            print(error)
        }
        return nil
    }
    
    func places(fileName: String) -> Places? {
        guard let jsonData = readJSON(from: fileName) else { return nil }
        
        let decoder = JSONDecoder()
        do {
            let result = try decoder.decode(Places.self, from: jsonData)
            return result
        } catch {
            print(error)
        }
        return nil
    }
    
}
