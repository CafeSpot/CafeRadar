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
                    Label("探索", systemImage: "magnifyingglass")                 }
            MapView()
                .tabItem {
                    Label("咖啡地圖", systemImage: "map.fill")
                }
            CollectionView()
                .tabItem {
                    Label("我的收藏", systemImage: "suit.heart")
                }
        }
        .accentColor(CafeColor.basicColor)
    }
}

#Preview {
    ContentView()
        .environment(StoreModel())
        .environment(MapViewModeModel())
        .environment(UserModel())

}
