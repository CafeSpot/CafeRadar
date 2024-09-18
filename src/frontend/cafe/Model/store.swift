//
//  store.swift
//  cafe
//
//  Created by 蔡沅恆 on 2024/2/1.
//

import Foundation
import SwiftUI
import GoogleMaps
import CoreLocation

struct Comment: Identifiable, Decodable {
    var id : UUID // Kept as let, but will be assigned a default in init
    var commentId: String
    var userId: String
    var cafeId: String
    var content: String

    // Coding keys to map JSON keys to properties
    private enum CodingKeys: String, CodingKey {
        case commentId, userId, cafeId, content
    }

    // Custom initializer for Decodable conformance
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID() // Generate a new UUID instead of decoding it
        self.commentId = try container.decode(String.self, forKey: .commentId)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.cafeId = try container.decode(String.self, forKey: .cafeId)
        self.content = try container.decode(String.self, forKey: .content)
    }
}

struct Store: Identifiable, Decodable{
    //id
    var id = UUID()
    var cafeId: String
    var name: String
    
    //basic info
    var openTime: String?
    var closeTime: String?
    var imageLinks: [String] = []
    var tags: [String] = []
    var lat: Double
    var lon: Double
    var distance: Double?
    
    //rating info
    var commentIds: [String] = []
    var envRate: Double?
    var spaceScore: Double?
    var lightScore: Double?
    var crowdRate: Double?
    var plugNum: Int?
    var seatNum: Int?
    
    //contact
    var address: String?
    var addressLink: String?
    var googleMapLink: String?
    var phone: String?
    var link: String?
    var ig: String?
    var igLink: String?
    var fb: String?
    var fbLink: String?
    

    // Initializer
    init(
        cafeId: String = "",
        name: String = "",
        openTime: String? = nil,
        closeTime: String? = nil,
        imageLinks: [String] = [],
        tags: [String] = [],
        lat: Double = 0,
        lon: Double = 0,
        distance: Double? = nil,
        commentIds: [String] = [],
        envRate: Double? = nil,
        spaceScore: Double? = nil,
        lightScore: Double? = nil,
        crowdRate: Double? = nil,
        plugNum: Int? = nil,
        seatNum: Int? = nil,
        address: String? = nil,
        addressLink: String? = nil,
        googleMapLink: String? = nil,
        phone: String? = nil,
        link: String? = nil,
        ig: String? = nil,
        igLink: String? = nil,
        fb: String? = nil,
        fbLink: String? = nil
    ) {
        self.cafeId = cafeId
        self.name = name
        self.openTime = openTime
        self.closeTime = closeTime
        self.imageLinks = imageLinks
        self.tags = tags
        self.lat = lat
        self.lon = lon
        self.distance = distance
        self.commentIds = commentIds
        self.envRate = envRate
        self.spaceScore = spaceScore
        self.lightScore = lightScore
        self.crowdRate = crowdRate
        self.plugNum = plugNum
        self.seatNum = seatNum
        self.address = address
        self.addressLink = addressLink
        self.googleMapLink = googleMapLink
        self.phone = phone
        self.link = link
        self.ig = ig
        self.igLink = igLink
        self.fb = fb
        self.fbLink = fbLink
    }

    
    init(from decoder: Decoder) throws{
        let container = try decoder.container(keyedBy: CodeingKeys.self)
        
        self.cafeId = try container.decodeIfPresent(String.self, forKey: .cafeId) ?? ""
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        self.openTime = try container.decodeIfPresent(String.self, forKey: .openTime) ?? nil
        self.closeTime = try container.decodeIfPresent(String.self, forKey: .closeTime) ?? nil
        self.imageLinks = try container.decodeIfPresent([String].self, forKey: .imageLinks) ?? []
        self.tags = try container.decodeIfPresent([String].self, forKey: .tags) ?? []
        self.lon = try container.decodeIfPresent(Double.self, forKey: .lon) ?? 0.0
        self.lat = try container.decodeIfPresent(Double.self, forKey: .lat) ?? 0.0
        self.distance = try container.decodeIfPresent(Double.self, forKey: .distance) ?? nil
        self.commentIds = try container.decodeIfPresent([String].self, forKey: .commentIds) ?? []
        self.envRate = try container.decodeIfPresent(Double.self, forKey: .envRate) ?? nil
        self.spaceScore = try container.decodeIfPresent(Double.self, forKey: .spaceScore) ?? nil
        self.lightScore = try container.decodeIfPresent(Double.self, forKey: .lightScore) ?? nil
        self.crowdRate = try container.decodeIfPresent(Double.self, forKey: .crowdRate) ?? nil
        self.plugNum = try container.decodeIfPresent(Int.self, forKey: .plugNum) ?? nil
        self.seatNum = try container.decodeIfPresent(Int.self, forKey: .seatNum) ?? nil
        self.address = try container.decodeIfPresent(String.self, forKey: .address) ?? nil
        self.addressLink = try container.decodeIfPresent(String.self, forKey: .addressLink) ?? nil
        self.googleMapLink = try container.decodeIfPresent(String.self, forKey: .googleMapLink) ?? nil
        self.phone = try container.decodeIfPresent(String.self, forKey: .phone) ?? nil
        self.link = try container.decodeIfPresent(String.self, forKey: .link) ?? nil
        self.ig = try container.decodeIfPresent(String.self, forKey: .ig) ?? nil
        self.igLink = try container.decodeIfPresent(String.self, forKey: .igLink) ?? nil
        self.fb = try container.decodeIfPresent(String.self, forKey: .fb) ?? nil
        self.fbLink = try container.decodeIfPresent(String.self, forKey: .fbLink) ?? nil
    }
    
    enum CodeingKeys: String, CodingKey{
        case cafeId
        case name
        case openTime
        case closeTime
        case imageLinks
        case tags
        case lat
        case lon
        case distance
        case commentIds
        case envRate
        case spaceScore
        case lightScore
        case crowdRate
        case plugNum
        case seatNum
        case address
        case addressLink
        case googleMapLink
        case phone
        case link
        case ig
        case igLink
        case fb
        case fbLink
    }
}

struct Recommend: Identifiable {
    let id = UUID()
    let title: String
    let cafeIds: [String]
    
    init(title: String, cafeIds: [String]) {
        self.title = title
        self.cafeIds = cafeIds
    }
}
