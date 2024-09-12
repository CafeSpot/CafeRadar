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


struct IdImage: Identifiable, Decodable {
    var id: UUID
    var image: Image
    
    private enum CodingKeys: String, CodingKey {
        case imageData = "image" // Assuming the image data is stored in this key
    }
    
    init(_ image: Image) {
        self.image = image
        self.id = UUID()
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = UUID()
        
        // Assuming image data is a base64 encoded string
        let imageData = try container.decode(String.self, forKey: .imageData)
        if let data = Data(base64Encoded: imageData),
           let uiImage = UIImage(data: data) {
            self.image = Image(uiImage: uiImage) // Convert UIImage to SwiftUI Image
        } else {
            self.image = Image(systemName: "photo") // Fallback if decoding fails
        }
    }
}

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
    var cafeId: Int = 0
    var name: String = ""
    
    //basic info
    var openTime: String = ""
    var closeTime: String = ""
    var seatNum: Int = -1
    var images: [IdImage] = []
    var tags: [Bool] = []
    var lon: Double = 0
    var lat: Double = 0
    
    //ratuing info
    var commentIds: [String] = []
    var envRating: Int = -1
    var spaceScore: Int = -1
    var lightScore: Int = -1
    var plugNum: Int = -1
    
    //google map info
    var place_id: String = ""
    var distance: Int = -1
    
    //contact
    var address = "no address no"
    var addressLink = "https://maps.app.goo.gl/5dyExrTXkTU1SBH79"
    var phone = "03-5205766"
    var ig = "ilikecoffee"
    var igLink = "https://"
    var fb = "ilikecoffee"
    var fbLink = "https://"
    
    //condition now
    var crowdRate: Int = -1
    var rate: Float = 3.5
    
    // CodingKeys enum to map JSON keys to struct properties
    enum CodingKeys: String, CodingKey {
        case id
        case cafeId
        case name
        case openTime
        case closeTime
        case seatNum
        case images
        case tags
        case lon
        case lat
        case commentIds
        case envRating
        case spaceScore
        case lightScore
        case plugNum
        case place_id
        case distance
        case address
        case addressLink
        case phone
        case ig
        case igLink
        case fb
        case fbLink
        case crowdRate
        case rate
    }

    
    // Initializer
    init(
        cafeId: Int = 0,
        name: String = "",
        openTime: String = "",
        closeTime: String = "",
        seatNum: Int = -1,
        images: [IdImage] = [],
        tags: [Bool] = [],
        lon: Double = 0,
        lat: Double = 0,
        commentIds: [String] = [],
        envRate: Int = -1,
        spaceScore: Int = -1,
        lightScore: Int = -1,
        plugNum: Int = -1,
        placeId: String = "",
        distance: Int = -1,
        address: String = "no address",
        addressLink: String = "https://maps.app.goo.gl/5dyExrTXkTU1SBH79",
        phone: String = "03-5205766",
        ig: String = "ilikecoffee",
        fb: String = "ilikecoffee",
        crowdRate: Int = -1,
    ) {
        self.cafeId = cafeId
        self.name = name
        self.openTime = openTime
        self.closeTime = closeTime
        self.seatNum = seatNum
        self.images = images
        self.tags = tags
        self.lat = lat
        self.lon = lon
        self.commentIds = commentIds
        self.envRating = envRating
        self.spaceScore = spaceScore
        self.lightScore = lightScore
        self.plugNum = plugNum
        self.place_id = place_id
        self.distance = distance
        self.address = address
        self.addressLink = addressLink
        self.phone = phone
        self.ig = ig
        self.igLink = igLink
        self.fb = fb
        self.fbLink = fbLink
        self.crowdRate = crowdRate
        self.rate = rate
    }
    init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            id = (try? container.decode(UUID.self, forKey: .id)) ?? UUID()
            cafeId = try container.decodeIfPresent(Int.self, forKey: .cafeId) ?? 0
            name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
            openTime = try container.decodeIfPresent(String.self, forKey: .openTime) ?? ""
            closeTime = try container.decodeIfPresent(String.self, forKey: .closeTime) ?? ""
            seatNum = try container.decodeIfPresent(Int.self, forKey: .seatNum) ?? 0
            images = try container.decodeIfPresent([IdImage].self, forKey: .images) ?? []
            tags = try container.decodeIfPresent([Bool].self, forKey: .tags) ?? []
            lon = try container.decodeIfPresent(Double.self, forKey: .lon) ?? 0
            lat = try container.decodeIfPresent(Double.self, forKey: .lat) ?? 0
            commentIds = try container.decodeIfPresent([String].self, forKey: .commentIds) ?? []
            envRating = try container.decodeIfPresent(Int.self, forKey: .envRating) ?? 0
            spaceScore = try container.decodeIfPresent(Int.self, forKey: .spaceScore) ?? 0
            lightScore = try container.decodeIfPresent(Int.self, forKey: .lightScore) ?? 0
            plugNum = try container.decodeIfPresent(Int.self, forKey: .plugNum) ?? 0
            place_id = try container.decodeIfPresent(String.self, forKey: .place_id) ?? ""
            distance = try container.decodeIfPresent(Int.self, forKey: .distance) ?? 0
            address = try container.decodeIfPresent(String.self, forKey: .address) ?? "no address"
            addressLink = try container.decodeIfPresent(String.self, forKey: .addressLink) ?? "https://maps.app.goo.gl/5dyExrTXkTU1SBH79"
            phone = try container.decodeIfPresent(String.self, forKey: .phone) ?? "03-5205766"
            ig = try container.decodeIfPresent(String.self, forKey: .ig) ?? "ilikecoffee"
            igLink = try container.decodeIfPresent(String.self, forKey: .igLink) ?? "https://"
            fb = try container.decodeIfPresent(String.self, forKey: .fb) ?? "ilikecoffee"
            fbLink = try container.decodeIfPresent(String.self, forKey: .fbLink) ?? "https://"
            crowdRate = try container.decodeIfPresent(Int.self, forKey: .crowdRate) ?? 1
            rate = try container.decodeIfPresent(Float.self, forKey: .rate) ?? 3.5
        }
}
 /*
  //place_id: str # google api提供
  //comment_id: Optional[List[str]] # User評論的id
  //env_rating: Optional[int] # User對工作讀書環境的評分
  tags: Optional[List[str]] # 讀書｜不限時 等hashtag
  //spot_id: Optional[List[str]]
  //plugs: Optional[conint(ge=1, le=5)] #插座數量 1~5
  //seat_size: Optional[conint(ge=1, le=5)] # 座位數量 1~5
  # music: str
  //light: Optional[conint(ge=1, le=5)] # 光線明亮程度 1~5
  //images: List[str] # from Google place detail API
  //opening_time: str
  //end_time: str
  */

struct GoogleInfo: Codable {
    // Properties from the JSON
    var business_status: String
    var icon: String
    var icon_background_color: String
    var icon_mask_base_uri: String
    var opening_hours: OpeningHours?
    var geometry: Geometry
    var photos: [Photo]?
    var place_id: String
    var rating: Float
    var reference: String
    var scope: String
    var types: [String]
    var user_ratings_total: Int
    var vicinity: String
    var name: String

    // Nested Codable structs
    struct OpeningHours: Codable {
        var open_now: Bool
    }

    struct Geometry: Codable {
        var location: Location
        var viewport: Viewport

        struct Location: Codable {
            var lat: Double
            var lng: Double
        }

        struct Viewport: Codable {
            var northeast: Location
            var southwest: Location
        }
    }

    struct Photo: Codable {
        var height: Int
        var width: Int
        var html_attributions: [String]
        var photo_reference: String
    }
}

/*
 {
    "business_status" : "OPERATIONAL",
    "geometry" :
    {
       "location" :
       {
          "lat" : 37.3506345,
          "lng" : -122.0496053
       },
       "viewport" :
       {
          "northeast" :
          {
             "lat" : 37.35212427989272,
             "lng" : -122.0483209701073
          },
          "southwest" :
          {
             "lat" : 37.34942462010727,
             "lng" : -122.0510206298927
          }
       }
    },
    "icon" : "https://maps.gstatic.com/mapfiles/place_api/icons/v1/png_71/generic_business-71.png",
    "icon_background_color" : "#7B9EB0",
    "icon_mask_base_uri" : "https://maps.gstatic.com/mapfiles/place_api/icons/v2/generic_pinlet",
    "name" : "Calibear Cyber Cafe 湾熊网咖",
    "opening_hours" :
    {
       "open_now" : false
    },
    "photos" :
    [
       {
          "height" : 1280,
          "html_attributions" :
          [
             "\u003ca href=\"https://maps.google.com/maps/contrib/110946876440829773004\"\u003eA Google User\u003c/a\u003e"
          ],
          "photo_reference" : "ATplDJYg49y3QPZ_ZFKaVs-eyRErOQnl-KrnPSGdUF-dJNlNC57d1HHXHeT3HIPI-SyR84tsjZUqE969HdgjlJOapj138wyyyR3lUVJAtk1fsSINTBiAIxO12Caf0UwJjP4oIimMGjdny0MYHYUrqD-aGeEziBeUcnu3SXXV1C6-6XqMUkoY",
          "width" : 1706
       }
    ],
    "place_id" : "ChIJtaDRJ522j4AR-em0X6SOPU8",
    "plus_code" :
    {
       "compound_code" : "9X22+75 Sunnyvale, California, USA",
       "global_code" : "849V9X22+75"
    },
    "rating" : 4.7,
    "reference" : "ChIJtaDRJ522j4AR-em0X6SOPU8",
    "scope" : "GOOGLE",
    "types" :
    [
       "cafe",
       "store",
       "food",
       "point_of_interest",
       "establishment"
    ],
    "user_ratings_total" : 411,
    "vicinity" : "1336 S Mary Ave, Sunnyvale"
 }
]
 */

struct Recommend: Identifiable {
    let id = UUID()
    let title: String
    let storeIDs: [Int]
    
    init(title: String, storeIDs: [Int]) {
        self.title = title
        self.storeIDs = storeIDs
    }
}



