//
//  cafeApp.swift
//  cafe
//
//  Created by 蔡沅恆 on 2024/2/1.
//

import SwiftUI
import GoogleMaps

//import FirebaseCore

/*
class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    return true
  }
}
 */

@main
struct cafeApp: App {
    @State private var storeModel = StoreModel()
    @State private var mapViewModeModel = MapViewModeModel()
    @State private var userModel: UserModel = UserModel()
    
    //@UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    init(){
        print("[file-cafeApp] api-key:",(Bundle.main.infoDictionary?["GOOGLE_API_KEY"] as? String)!)
        GMSServices.provideAPIKey((Bundle.main.infoDictionary?["GOOGLE_API_KEY"] as? String)!)
        //FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(storeModel)
                .environment(mapViewModeModel)
                .environment(userModel)
        }
    }
}
