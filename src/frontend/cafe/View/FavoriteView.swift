//
//  CollectionView.swift
//  cafe
//
//  Created by 蔡沅恆 on 2024/2/1.
//

import SwiftUI

struct FavoriteView: View {
    
    @Environment(StoreModel.self) private var storeModel
    @Environment(UserModel.self) private var userModel
    @State private var selectionText: String = ""
    @State private var selectionsType: [Bool] = [false, false, false, false, false]
    
    var favoriteCafes: [Store] {
        return storeModel.storeCollection.filter {userModel.user.favCafeIds.contains($0.cafeId)}
    }
    
    var body: some View {
        NavigationStack {
            VStack{
                SearchBarView(ifDistance: false)
                //.foregroundColor(.black)
                    .padding(.top,7)
                    .padding(.bottom,10)
                    .padding(.leading,16)
                    .background(Color.clear)
                Spacer()
                
                ScrollView(showsIndicators: false) {
                    LazyVStack {
                        ForEach(favoriteCafes) { store in
                            StoreSimpleInfoView(store: store,imgNum: 3)
                        }
                    }
                }
                .padding(4)
            }
        }
    }
}

#Preview {
    FavoriteView()
        .environment(StoreModel())
        .environment(MapViewModeModel())
        .environment(UserModel())
}
