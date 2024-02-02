//
//  cafeApp.swift
//  cafe
//
//  Created by 蔡沅恆 on 2024/2/1.
//

import SwiftUI

@main
struct cafeApp: App {
    @State private var storeModel = StoreModel()
    var body: some Scene {
        WindowGroup {
            ContentView().environment(storeModel)
        }
    }
}
