//
//  ContentView.swift
//  cafe
//
//  Created by 蔡沅恆 on 2024/2/1.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var authModel : AuthManager
    @Environment(StoreModel.self) private var storeModel
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
                        .onAppear(){
                            storeModel.reset_searchCondition()
                        }
                    FavoriteView()
                        .tabItem {
                            Label("我的收藏", systemImage: "suit.heart")
                        }
                        .onAppear(){
                            storeModel.reset_searchCondition()
                        }
                    UserInfoView()
                        .tabItem {
                            Label("設定", systemImage: "book.and.wrench")
                        }
                        .onAppear(){
                            storeModel.reset_searchCondition()
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
