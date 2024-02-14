//
//  StoreModel.swift
//  cafe
//
//  Created by 蔡沅恆 on 2024/2/1.
//

import Foundation
import CoreLocation

@Observable
class StoreModel: storeModelSositionManager{
//class StoreModel{
    //the position of the user. when user move, send the request to get the nearby caffee
    
    var storeBuffer: [Store]
    var storeCollection: [Store]
    
    var types: [String] = ["空位", "插座", "不限時", "讀書", "供應正餐", "音樂", "戶外"]
    
    var storePlaceIds: [StorePlaceId]
    
    //init() {
    override init() {
        self.storeBuffer = []
        self.storeCollection = []
        self.storePlaceIds = []
        super.init()
        self.initLoad()
    }
    
    func initLoad(){
        self.storeBuffer = testStores
        self.storeCollection = testStores
    }
    
    //request googlemapAPI-nearbySearch and set the result to the storeBuffer
    func searchText(text: String){
        storeBuffer = Array(storeBuffer.prefix(2))
    }
    
    func getNearbyFromGoogleMap(){
        
        let requestURL: String
        if let position = self.position{
            requestURL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?keyword=cafe&location=\(position.coordinate.latitude)%2C\(position.coordinate.longitude)&radius=5000&key=AIzaSyA56wAlcA_gChuocEng24X_qi6OKIGdkaU"
        }else{
            requestURL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?keyword=cafe&location=25.05232586760929%2C121.52068772564594&radius=5000&key=YOUR_API_KEY"
        }
        //keyward(search for relevance) vs type(retrict and specify one type at once request)
        //place's type in google map: https://developers.google.com/maps/documentation/places/web-service/supported_types
        //new type: https://developers.google.com/maps/documentation/places/web-service/place-types
        // choose the return field: https://developers.google.com/maps/documentation/places/web-service/choose-fields
        
        guard let url = URL(string: requestURL) else {
            print("Invalid URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Invalid response")
                return
            }
            
            if let data = data {
                
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("JSON: \(jsonString)")
                }
                
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(StorePlaceIds.self, from: data)
                    DispatchQueue.main.async {
                        self.storePlaceIds = result.results
                    }
                } catch {
                    print("Error parsing JSON: \(error.localizedDescription)")
                }
            }
        }
        task.resume()
    }
    
    struct StorePlaceIds: Codable{
        let results: [StorePlaceId]
    }
    
    struct StorePlaceId: Codable, Identifiable{
        var id = UUID()
        var place_id: String
        var type: String
        var name: String
        var photos: [PhotosResults]     //照片
        var reviews: [Reviews]          //評論
        
        struct PhotosResults: Codable{
            var photo_reference: String
        }
        
        struct Reviews: Codable{
            var author_name: String
            var profile_photo_url: String
            var relative_time_description: String
            var text: String
            var time: Date
        }
    }
}

@Observable
class storeModelSositionManager: NSObject, CLLocationManagerDelegate{  //positionManager
    private var locationManager: CLLocationManager
    var position: CLLocation?
    var basicPosition: CLLocation? = CLLocation()
    
    

    override init() {
        locationManager = CLLocationManager()
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 0.4
        locationManager.startUpdatingLocation()
        locationManager.requestWhenInUseAuthorization()
     }
     
     
     func requestPermission() {
        locationManager.requestWhenInUseAuthorization()
     } // this fubcatuin call to request the position auth from iphone user(optional)
     
     
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        self.position = locations.first
        if let location = locations.first{
            if ifResquestNearbyData(la: location.coordinate.latitude, lo: location.coordinate.longitude) {
                //sent the request api to get the nearby store
                print("get the nearby store info")
                
                self.basicPosition = locations.first
            }
        }
    }//if the psition chanage, this fucyion would be call
    
    func ifResquestNearbyData(la: Double , lo: Double) -> Bool {
        if let basicPosition = self.basicPosition {
            return abs(basicPosition.coordinate.latitude - la) > 0.001 || abs(basicPosition.coordinate.longitude - lo) > 0.001
        } else {
            return false
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
       print("Location manager failed with error: \(error.localizedDescription)")
    }//show if there is error
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
           case .notDetermined:
           print("status: Not Determined")
        case .restricted:
           print("status: Restricted")
           case .denied:
        print("status: Denied")
           case .authorizedAlways, .authorizedWhenInUse:
           print("status: Authorized")
        @unknown default:
           print("status: Unknown")
        }
    }//to show the autorization change
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






