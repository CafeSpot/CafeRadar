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
    
    // [class setting]
    let bufferSize = 100
    
    // [data from server] - global
    var storeBuffer: [Store]
    var recommends: [Recommend]
    var typeNames: [String]
    
    
    // [maintain data]
    var storeCollection: [Store] { self.storeBuffer.filter { self.filtStore_selection(store: $0) } }  // the set of the store show on the map page and the command page
    var storeMap: [Store] { self.storeBuffer.filter { self.filtStore_selection(store: $0) } }
    var storeRecommends: [[Store]] {
        self.recommends.map { recommand in
            self.storeBuffer.filter { store in
                recommand.cafeIds.contains(store.cafeId)
            }
        }
    }
    var selectionText: String = ""  // keyword to search
    var selectionsType: [Bool] = []  // key type to search
    var selectedDistance: Double = 10000
    
    //init() {
    override init() {
        self.storeBuffer = []
        self.recommends = []
        self.typeNames = []
        
        super.init()
        self.initLoad()
    }
    
    // [modify] modify to the google map api or ours in the future !!!
    // the method request the recommend store info from the server, with info user_position, user_id, user_favor...
    func initLoad(){
        self.storeBuffer = testStores
        self.recommends = testRecommends
        self.typeNames = testTypeNames
        
        self.selectionsType = Array(repeating: true, count: self.typeNames.count)
        print("get the ",self.storeBuffer.count," stores from the test data")
    }
    
    //??? request googlemapAPI-nearbySearch and set the result to the storeBuffer
    func searchText(text: String){
        storeBuffer = Array(storeBuffer.prefix(2))
    }

    // while the basicPosition change, this function would be called and send the http get request to our server
    override func basicPositionDidChange() {
        requestStoreInfo()
    }
    func requestStoreInfo() {
        if let position = basicPosition {
            print("[StoreModel - Current Location]: Latitude: \(position.coordinate.latitude), Longitude: \(position.coordinate.longitude), distance:\(selectedDistance)")
            
             //guard let url = URL(string: "http://127.0.0.1:8000/cafe/search/?lon=\(position.coordinate.longitude)&lat=\(position.coordinate.latitude)&text=\(selectionText)&dis=\(selectedDistance)") else { return }
            guard let url = URL(string: "http://127.0.0.1:8000/cafe/search/?lon=\(120.9675)&lat=\(24.8138)&text=\(selectionText)&dis=\(selectedDistance)") else { return }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    do {
                        let decodedData = try JSONDecoder().decode(Response.self, from: data)
                        
                        // Update the UI on the main thread
                        DispatchQueue.main.async {
                            self.storeBuffer = decodedData.data
                            print(self.storeBuffer[0])
                            print("Data received and decoded: \(self.storeBuffer.count)")
                        }
                    } catch {
                        print("Error decoding data: \(error)")
                    }
                }
            }.resume()
        }
    }
    
    
    // this function is called by [override func locationManager], used to request the nearby store by google map api
    // ~~~ move to another file, and return the value
    func getNearbyFromGoogleMap(){}
    
    
    // this method is the filter function which return if the "store" is correspond the selected conditions
    func filtStore_selection(store: Store) -> Bool{
        var ansText: Bool = false
        var ansType: Bool = false
        var ansDistance: Bool = false
        
        ansText = selectionText=="" ? true : store.name.contains(selectionText)
        

        //type filter design?
        for index in typeNames{
            if(store.tags.contains(index)){
                ansType = true
                break
            }
        }


        if let position = self.position{
            let location1 = CLLocation(latitude: position.coordinate.latitude, longitude:position.coordinate.longitude)
            let location2 = CLLocation(latitude: store.lat, longitude: store.lon)
            ansDistance = location1.distance(from: location2) < selectedDistance*100000000 ? true : false
        }else{
            ansDistance = true
        }
        
        return ansText && ansType && ansDistance
    }
}

@Observable
class storeModelPositionManager: NSObject, CLLocationManagerDelegate{  //positionManager
    private var locationManager: CLLocationManager
    var position: CLLocation?
    var basicPosition: CLLocation? = CLLocation() {
        didSet {basicPositionDidChange()}
    }
    
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
        print("[storeModelPositionManager]: requestWhenInUseAuthorization")
        locationManager.requestWhenInUseAuthorization()
    } // this fubcatuin call to request the position auth from iphone user(optional)
    
    func basicPositionDidChange() {
        if let position = basicPosition {
            print("Current Location: Latitude: \(position.coordinate.latitude), Longitude: \(position.coordinate.longitude)")
        }
    }
     
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        self.position = locations.first
        if let location = locations.first{
            if ifResquestNearbyData(la: location.coordinate.latitude, lo: location.coordinate.longitude) {
                //sent the request api to get the nearby store
                print("[storeModelPositionManager]: get the nearby store info")
                
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
       print("[storeModelPositionManager]: Location manager failed with error: \(error.localizedDescription)")
    }//show if there is error
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
           case .notDetermined:
           print("[storeModelPositionManager]: status ~ Not Determined")
        case .restricted:
           print("[storeModelPositionManager]: status ~ Restricted")
           case .denied:
        print("[storeModelPositionManager]: status ~ Denied")
           case .authorizedAlways, .authorizedWhenInUse:
           print("[storeModelPositionManager]: status ~ Authorized")
        @unknown default:
           print("[storeModelPositionManager]: status ~ Unknown")
        }
    }//to show the autorization change
 }






