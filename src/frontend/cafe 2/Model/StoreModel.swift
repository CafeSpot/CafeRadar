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
    
    
    override func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        self.position = locations.first
        if let location = locations.first{
            if ifResquestNearbyData(la: location.coordinate.latitude, lo: location.coordinate.longitude) {
                //sent the request api to get the nearby store
                print("get the nearby store info")
                
                self.basicPosition = locations.first
            }
        }
    }//if the psition chanage, this fucyion would be call
     
    
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
     
     
     func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
         position = locations.first
         basicPosition = locations.first
     }//if the psition chanage, this fucyion would be call
     
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
    
    func ifResquestNearbyData(la: Double , lo: Double) -> Bool {
        if let basicPosition = self.basicPosition {
            return abs(basicPosition.coordinate.latitude - la) > 0.001 || abs(basicPosition.coordinate.longitude - lo) > 0.001
        } else {
            return false
        }
    }
 }






