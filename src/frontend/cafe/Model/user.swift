//
//  user.swift
//  cafe
//
//  Created by henry on 2024/9/24.
//

import Foundation

struct User: Identifiable, Decodable {
    // `id` is automatically generated
    var id = UUID()
    
    var userId: String?
    var name: String?
    var favCafeIds: Set<String> = []
    
    // Custom initializer with default values
    init(
        userId: String? = nil,
        name: String? = nil,
        fav_cafeIds: [String] = []
    ) {
        self.userId = userId ?? "12356" // Provide default value if needed
        self.name = name ?? "aaa"       // Provide default value if needed
        self.favCafeIds = Set(favCafeIds)
    }
    
    // Decoder initializer
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.userId = try container.decodeIfPresent(String.self, forKey: .userId) ?? ""
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        self.favCafeIds = try container.decodeIfPresent(Set<String>.self, forKey: .favCafeIds) ?? Set<String>()
    }
    
    // Coding keys for decoding
    enum CodingKeys: String, CodingKey {
        case name
        case userId
        case favCafeIds
    }
}
