//
//  UserModel.swift
//  cafe
//
//  Created by 蔡沅恆 on 2024/2/1.
//

import Foundation
import CoreLocation


@Observable
class UserModel: positionManager{
    var name: String
    var ID: Int
    
    override init(){
        self.name = "aaa"
        self.ID = 123456
        super.init()
    }
}


class positionManager: NSObject, CLLocationManagerDelegate{  //positionManager
    private var locationManager: CLLocationManager
    var position: CLLocation?
    var latitude: Double?
    var longitude: Double?

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
         latitude = locations.first?.coordinate.latitude
         longitude = locations.first?.coordinate.longitude
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
 }

