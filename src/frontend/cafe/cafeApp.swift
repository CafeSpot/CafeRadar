//
//  cafeApp.swift
//  cafe
//
//  Created by 蔡沅恆 on 2024/2/1.
//
import UIKit
import SwiftUI
import GoogleMaps
import FirebaseCore
import FirebaseAuth


//import FirebaseCore
class AppDelegate: NSObject, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // [google map service]
        GMSServices.provideAPIKey((Bundle.main.infoDictionary?["GOOGLE_API_KEY"] as? String)!)
        
        // [direbae service]
        FirebaseApp.configure()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("App entered background")
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        print("App will enter foreground")
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        print("App became active")
    }

    func applicationWillResignActive(_ application: UIApplication) {
        print("App will resign active")
    }

    func applicationWillTerminate(_ application: UIApplication) {
        print("App will terminate")
    }
}

@main
struct cafeApp: App {
    @State private var storeModel = StoreModel()
    @State private var mapViewModeModel = MapViewModeModel()
    @State private var userModel: UserModel = UserModel()
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    init(){
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
