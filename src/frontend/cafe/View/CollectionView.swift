//
//  CollectionView.swift
//  cafe
//
//  Created by 蔡沅恆 on 2024/2/1.
//

import SwiftUI

struct CollectionView: View {
    
    @Environment(StoreModel.self) private var storeModel
    @Environment(UserModel.self) private var userModel
    @State private var selectionText: String = ""
    @State private var selectionsType: [Bool] = [false, false, false, false, false]
    
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
                    VStack {
                        ForEach(storeModel.storeCollection) { store in
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
    CollectionView()
        .environment(StoreModel())
        .environment(MapViewModeModel())
        .environment(UserModel())
}
