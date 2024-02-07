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
    var cafename: String = ""
    
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
    var placeId: String = ""
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
