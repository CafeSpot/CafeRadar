//
//  ContentView.swift
//  cafe
//
//  Created by 蔡沅恆 on 2024/2/1.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            ExploreView()
                .tabItem {
                    Label("explore", systemImage: "star")
                 }
            MapView()
                .tabItem {
                    Label("map", systemImage: "star")
                }
            CollectionView()
                .tabItem {
                    Label("collection", systemImage: "star")
                }
        }
    }
}

#Preview {
    ContentView()
        .environment(StoreModel())
        .environment(MapViewModeModel())
        .environment(UserModel())

}
