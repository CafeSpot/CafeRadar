//
//  ExploreView.swift
//  cafe
//
//  Created by 蔡沅恆 on 2024/2/1.
//

import SwiftUI

struct ExploreView: View {
    @Environment(StoreModel.self) private var storeModel
    @Environment(UserModel.self) private var userModel
    @State private var selectionText: String = ""
    @State private var selectionsType: [Bool] = [false, false, false, false, false]
    
    var body: some View {
        NavigationStack {
            VStack{
                SearchBarView(ifType: false, ifDistance: false)
                //.foregroundColor(.black)
                    .padding(.top,7)
                    .padding(.bottom,10)
                    .padding(.leading,16)
                    .background(Color.clear)
                Spacer()
                
                
                // [modify] there are a lot of the topic 本月主打, 貓店長值班, 好氣份好心情. modify it to the list which record the topic and its recommand store id
                ScrollView(showsIndicators: false) {
                    
                    // 本月主打
                    HStack {
                        Text("本月主打")
                            .font(.system(size: 24))
                            .bold()
                        Spacer()
                    }
                    .padding()
                    Image("cafe1")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 250, height: 250)
                        .cornerRadius(17)
                        .clipped()
                    
                    // 貓店長值班
                    HStack {
                        Text("貓店長值班")
                            .font(.system(size: 24))
                            .bold()
                        Spacer()
                    }
                    .padding()
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(storeModel.storeCollection) { store in
                                StoreSimpleInfoView(store: store,imgNum: 2)
                            }
                        }
                    }
                    .padding(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12))
                    .frame(minHeight: 160)
                    
                    // 好氣份好心情
                    HStack {
                        Text("好氣份好心情")
                            .font(.system(size: 24))
                            .bold()
                        Spacer()
                    }
                    .padding()
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(storeModel.storeCollection) { store in
                                StoreSimpleInfoView(store: store,imgNum: 2)
                            }
                        }
                    }
                    .padding(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12))
                    .frame(minHeight: 160)
                    
                    // 網友高分推薦
                    HStack {
                        Text("網友高分推薦")
                            .font(.system(size: 24))
                            .bold()
                        Spacer()
                    }
                    .padding()
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(storeModel.storeCollection) { store in
                                StoreSimpleInfoView(store: store,imgNum: 2)
                            }
                        }
                    }
                    .padding(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12))
                    .frame(minHeight: 160)
                }
            }
        }
    }
}

#Preview {
    ExploreView()
        .environment(StoreModel())
        .environment(MapViewModeModel())
        .environment(UserModel())
}
