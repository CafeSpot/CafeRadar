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
    
    init(){
        GMSServices.provideAPIKey("AIzaSyA56wAlcA_gChuocEng24X_qi6OKIGdkaU")
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(storeModel)
                .environment(mapViewModeModel)
        }
    }
}
