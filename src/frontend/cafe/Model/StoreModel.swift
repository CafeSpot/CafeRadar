//
//  StoreModel.swift
//  cafe
//
//  Created by 蔡沅恆 on 2024/2/1.
//

import Foundation
import CoreLocation
import GoogleMaps

@Observable
class StoreModel: storeModelSositionManager{
//class StoreModel{
    //the position of the user. when user move, send the request to get the nearby caffee
    
    var storeBuffer: [Store]
    var storeCollection: [Store]
    
    var types: [String] = ["空位", "插座", "不限時", "讀書", "供應正餐", "音樂", "戶外"]
    
    //init() {
    override init() {
        self.storeBuffer = []
        self.storeCollection = []
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
            requestURL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?keyword=cafe&location=\(position.coordinate.latitude)%2C\(position.coordinate.longitude)&radius=5000&key=YOUR_API_KEY"
        }else{
            requestURL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?keyword=cafe&location=25.05232586760929%2C121.52068772564594&radius=5000&key=YOUR_API_KEY"
        }
        
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
                
                //if let jsonString = String(data: data, encoding: .utf8) {print("JSON: \(jsonString)")}
                
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(StorePlaceIds.self, from: data)
                    DispatchQueue.main.async {
                        self.convertGoogleInfoToStore(googleInfoBuffer: result.results)
                        print("call the google map api and add the info to buffer successfully!!!")
                    }
                } catch let DecodingError.dataCorrupted(context) {
                    print(context)
                } catch let DecodingError.keyNotFound(key, context) {
                    print("Key '\(key)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch let DecodingError.valueNotFound(value, context) {
                    print("Value '\(value)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch let DecodingError.typeMismatch(type, context)  {
                    print("Type '\(type)' mismatch:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch {
                    print("error: ", error)
                }//https://stackoverflow.com/questions/46959625/the-data-couldn-t-be-read-because-it-is-missing-error-when-decoding-json-in-sw
            }
        }
        task.resume()
    }
    
    func convertGoogleInfoToStore(googleInfoBuffer: [GoogleInfo]){
        for item in googleInfoBuffer{
            let store =  Store(
                cafeId: "",
                name: item.name,
                openTime: "8:00",
                closeTime: "18:00",
                seatNum: 50,
                images: [],
                tags: item.types.map{Idtag($0.replacingOccurrences(of: "_", with: " "))},
                commentIds: [],
                envRating: 1,
                spaceScore: 3,
                lightScore: 3,
                plugNum: 4,
                place_id: "1223",
                distance: 200,
                marker: GMSMarker(position: CLLocationCoordinate2D(latitude: item.geometry.location.lat, longitude: item.geometry.location.lng)),
                crowdRate: 1
            )
            self.storeBuffer.append(store)
            self.storeCollection.append(store)
        }
    }
    
    struct StorePlaceIds: Codable{
        var results: [GoogleInfo]
        var status: String
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






