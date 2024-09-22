//
//  ContentView.swift
//  cafe
//
//  Created by 蔡沅恆 on 2024/2/1.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var authModel : AuthManager
    var bottomPadding : CGFloat = 10
    var topPadding : CGFloat = 10
    
    var body: some View {
        if authModel.signedIn || authModel.notRequireAuth{
            TabView {
                    ExploreView()
                    .tabItem {
                        Label("探索", systemImage: "magnifyingglass")
                    }
                    MapView()
                        .padding(.bottom, bottomPadding)
                        .tabItem {
                            Label("咖啡地圖", systemImage: "map.fill")
                        }
                    CollectionView()
                        .tabItem {
                            Label("我的收藏", systemImage: "suit.heart")
                        }
                    SettingView()
                        .tabItem {
                            Label("設定", systemImage: "book.and.wrench")
                        }
            }
            .accentColor(CafeColor.basicColor)
        }
        else{
            WelcomeView()
        }
    }
}

#Preview {
    ContentView()
        .environment(StoreModel())
        .environment(MapViewModeModel())
        .environment(UserModel())
        .environmentObject(AuthManager())

}
