//
//  POI.swift
//  InteractiveClusteringMap
//
//  Created by Oh Donggeon on 2020/11/21.
//

import Foundation

struct POI: Codable {
    
    let x, y: Double
    let id: Int64
    let name: String?
    let imageUrl: String?
    let category: String?
    
    init(x: Double, y: Double, id: Int64, name: String?, imageUrl: String?, category: String?) {
        self.x = x
        self.y = y
        self.id = id
        self.name = name
        self.imageUrl = imageUrl
        self.category = category
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = Int64(try container.decode(String.self, forKey: .id)) ?? 0
        x = Double(try container.decode(String.self, forKey: .x)) ?? 0
        y = Double(try container.decode(String.self, forKey: .y)) ?? 0
        name = try? container.decode(String.self, forKey: .name)
        imageUrl = try? container.decode(String.self, forKey: .imageUrl)
        category = try? container.decode(String.self, forKey: .category)
    }

}
