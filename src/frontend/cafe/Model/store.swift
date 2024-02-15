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


struct IdImage: Identifiable {
    let id = UUID()
    let image: Image
    
    init(_ image: Image) {
        self.image = image
    }
}

struct Idtag: Identifiable {
    let id = UUID()
    let tag: String
    var selected: Bool = true
    
    init(_ tag: String) {
        self.tag = tag
    }
}

struct Comment: Identifiable {
    let id = UUID()
    var commentId: String
    var userId: String
    var cafeId: String
    var content: String
}

struct Store: Identifiable{
    //id
    let id = UUID()
    var cafeId: String = ""
    var name: String = ""
    
    //basic info
    var openTime: String = ""
    var closeTime: String = ""
    var seatNum: Int = -1
    var images: [IdImage] = []
    var tags: [Idtag] = []
    
    //ratuing info
    var commentIds: [String] = []
    var envRating: Int = -1
    var spaceScore: Int = -1
    var lightScore: Int = -1
    var plugNum: Int = -1
    
    //google map info
    var place_id: String = ""
    var distance: Int = -1
    var marker: GMSMarker
        //https://developers.google.com/maps/documentation/ios-sdk/reference/interface_g_m_s_marker
        //  let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: x, longitude: y))
        //  marker.title = "name"
    
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



