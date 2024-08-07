//
//  cafeApp.swift
//  cafe
//
//  Created by 蔡沅恆 on 2024/2/1.
//

import SwiftUI
import GoogleMaps

@main
struct cafeApp: App {
    @State private var storeModel = StoreModel()
    @State private var mapViewModeModel = MapViewModeModel()
    @State private var userModel: UserModel = UserModel()
    
    init(){
        GMSServices.provideAPIKey("GOOGLE_API_KEY")
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
