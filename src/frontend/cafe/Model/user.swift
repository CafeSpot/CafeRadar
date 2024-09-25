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
    var email: String?
    var phone: String?
    
    // Custom initializer with default values
    init(
        userId: String? = nil,
        name: String? = nil,
        email: String? = nil,
        phone: String? = nil,
        fav_cafeIds: [String] = []
    ) {
        self.userId = userId ?? "" // Provide default value if needed
        self.name = name ?? ""       // Provide default value if needed
        self.email = ""
        self.phone = ""
        self.favCafeIds = Set(favCafeIds)
    }
    
    // Decoder initializer
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.userId = try container.decodeIfPresent(String.self, forKey: .userId) ?? ""
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        self.favCafeIds = try container.decodeIfPresent(Set<String>.self, forKey: .favCafeIds) ?? Set<String>()
        self.email = try container.decodeIfPresent(String.self, forKey: .email) ?? ""
        self.phone = try container.decodeIfPresent(String.self, forKey: .phone) ?? ""
    }
    
    // Coding keys for decoding
    enum CodingKeys: String, CodingKey {
        case name
        case userId
        case email
        case phone
        case favCafeIds
    }
}
