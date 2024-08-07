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
class StoreModel: storeModelPositionManager{
//class StoreModel{
    //the position of the user. when user move, send the request to get the nearby caffee
    
    let bufferSize = 100
    
    var storeBuffer: [Store]
    var storeCollection: [Store] { self.storeBuffer.filter { self.filtStore(store: $0) } }  // the set of the store show on the map page and the command page
    
    var types: [String] = ["空位", "插座", "不限時", "讀書", "供應正餐", "音樂", "戶外"]
    
    var selectionText: String = ""  // keyword to search
    var selectionsType: [Idtag] = []  // key type to search
    var selectionsTypeCount: Int = 0  // how many key type was choosed
    var selectedDistance: Double = 10000
    
    //init() {
    override init() {
        let loadtype = [Idtag("空位"), Idtag("插座"), Idtag("不限時"), Idtag("讀書"), Idtag("供應正餐"), Idtag("音樂"), Idtag("戶外")]
        self.selectionsType = loadtype
        self.selectionsTypeCount = loadtype.count
        self.storeBuffer = []
        super.init()
        self.initLoad()
    }
    
    // [modify] modify to the google map api or ours in the future !!!
    // the method request the recommend store info from the server, with info user_position, user_id, user_favor...
    func initLoad(){
        self.storeBuffer = testStores
    }
    
    //??? request googlemapAPI-nearbySearch and set the result to the storeBuffer
    func searchText(text: String){
        storeBuffer = Array(storeBuffer.prefix(2))
    }
    
    // get the nearby store
    //if the psition chanage, this fucyion would be call
    override func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        self.position = locations.first
        if let location = locations.first{
            if ifResquestNearbyData(la: location.coordinate.latitude, lo: location.coordinate.longitude) {
                getNearbyFromGoogleMap()
                print("get the nearby store info")
                
                self.basicPosition = locations.first
            }
        }
    }
    
    
    // this function is called by [override func locationManager], used to request the nearby store by google map api
    // ~~~ move to another file, and return the value
    func getNearbyFromGoogleMap(){
        let requestURL: String
        if let position = self.position{
            requestURL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?keyword=cafe&location=\(position.coordinate.latitude)%2C\(position.coordinate.longitude)&radius=5000&key=a"
            //AIzaSyA56wAlcA_gChuocEng24X_qi6OKIGdkaU
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
    
    // this function is called by [getNearbyFromGoogleMap], used to convert the return data from the google api to the store struct
    // ~~~ move to another file, and return the value
    func convertGoogleInfoToStore(googleInfoBuffer: [GoogleInfo]){
        var count = 0
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
                crowdRate: 1,
                rate: item.rating
            )
            self.storeBuffer.append(store)
            if(self.storeBuffer.count>bufferSize){
                self.storeBuffer.removeFirst(1)
            }
            count+=1
        }
        print("find \(count) cafe stores!")
    }
    
    
    // this method is the filter function which return if the "store" is correspond the selected conditions
    func filtStore(store: Store) -> Bool{
        var ansText: Bool = false
        var ansType: Bool = false
        var ansDistance: Bool = false
        
        ansText = selectionText=="" ? true : store.name.contains(selectionText)
        

        //type filter design?
        for type in selectionsType{
            for tag in store.tags{
                if tag.tag==type.tag && type.selected{
                    ansType = true
                }
            }
        }

        
        if let position = self.position{
            let location1 = CLLocation(latitude: position.coordinate.latitude, longitude:position.coordinate.longitude)
            let location2 = CLLocation(latitude: store.marker.position.latitude, longitude: store.marker.position.longitude)
            ansDistance = location1.distance(from: location2) < selectedDistance*100000000 ? true : false
        }else{
            ansDistance = true
        }
        return ansText && ansType && ansDistance
    }
    
    struct StorePlaceIds: Codable{
        var results: [GoogleInfo]
        var status: String
    }

}

@Observable
class storeModelPositionManager: NSObject, CLLocationManagerDelegate{  //positionManager
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






