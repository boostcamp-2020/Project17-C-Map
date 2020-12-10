//
//  POI.swift
//  InteractiveClusteringMap
//
//  Created by Oh Donggeon on 2020/11/21.
//

import Foundation

struct POI: Codable {
    
    let x, y: Double
    let id: String 
    let name: String?
    let imageUrl: String?
    let category: String?
    
    init(x: Double, y: Double, id: String, name: String? = nil, imageUrl: String? = nil, category: String? = nil) {
        self.x = x
        self.y = y
        self.id = id
        self.name = name
        self.imageUrl = imageUrl
        self.category = category
    }
    
    init(x: Double, y: Double, name: String? = nil, imageUrl: String? = nil, category: String? = nil) {
        self.init(x: x, y: y, id: UUID().uuidString, name: name, imageUrl: imageUrl, category: category)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = UUID().uuidString
        x = Double(try container.decode(String.self, forKey: .x)) ?? 0
        y = Double(try container.decode(String.self, forKey: .y)) ?? 0
        name = try? container.decode(String.self, forKey: .name)
        imageUrl = try? container.decode(String.self, forKey: .imageUrl)
        category = try? container.decode(String.self, forKey: .category)
    }

}
