//
//  Geocoding.swift
//  InteractiveClusteringMap
//
//  Created by Seungeon Kim on 2020/12/10.
//

import Foundation

// MARK: - Welcome
struct Geocoding: Codable, CustomStringConvertible {
    let results: [Address]
    var description: String {
        guard  let result = results.first else {
            return ""
        }
        
        return result.region.description + result.land.description
    }
}

// MARK: - Result
struct Address: Codable {
    let region: Region
    let land: Land
}

// MARK: - Land
struct Land: Codable, CustomStringConvertible {
    let type, name, number1, number2: String
    let addition0, addition1, addition2, addition3, addition4: Addition
    var description: String {
        let number = number2 == "" ? number1 : "\(number1)-\(number2)"
        let building = addition0.description + addition1.description + addition2.description + addition3.description + addition4.description
        return "\(name) \(number) (\(building))"
    }
}

// MARK: - Addition
struct Addition: Codable, CustomStringConvertible {
    let type, value: String
    var description: String {
        return type == "building" ? value : ""
    }
}

// MARK: - Region
struct Region: Codable, CustomStringConvertible {
    let area0, area1, area2, area3, area4: Area
    var description: String {
        return "\(area1.name) \(area2.name) \(area3.name) \(area4.name)"
    }
}

// MARK: - Area
struct Area: Codable {
    let name: String
}
