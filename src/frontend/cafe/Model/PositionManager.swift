//
//  PositionModel.swift
//  cafe
//
//  Created by henry on 2024/9/22.
//

import Foundation
import GoogleMaps

class PositionManager: NSObject, CLLocationManagerDelegate, ObservableObject{  //positionManager
    private var locationManager: CLLocationManager
    var position: CLLocation?
    var basicPosition: CLLocation? = CLLocation()
    
    private var updateFuncList: [(CLLocation) -> Void] = []
    
    override init() {
        locationManager = CLLocationManager()
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 0.4
        locationManager.startUpdatingLocation()
        locationManager.requestWhenInUseAuthorization()
    }
    
    func set(_ function: @escaping (CLLocation) -> Void) {
        updateFuncList.append(function)
    }
    
    func update(with parameter: CLLocation) {
        for function in updateFuncList {
            function(parameter) // Call the function with the provided parameter
        }
    }
     
    func requestPermission() {
        print("[storeModelPositionManager]: requestWhenInUseAuthorization")
        locationManager.requestWhenInUseAuthorization()
    } // this fubcatuin call to request the position auth from iphone user(optional)
     
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        self.position = locations.first
        if let location = locations.first{
            if ifResquestNearbyData(la: location.coordinate.latitude, lo: location.coordinate.longitude) {
                //sent the request api to get the nearby store
                print("[storeModelPositionManager]: get the nearby store info")
                
                self.basicPosition = locations.first
                
                for function in self.updateFuncList {
                    if let basicPosition = self.basicPosition{
                        function(basicPosition)
                    }
                }
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
