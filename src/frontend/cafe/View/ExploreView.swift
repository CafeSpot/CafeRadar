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
                    VStack(){
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
                    }
                    .padding(10)
                    
                    // different topic
                    ForEach(0..<storeModel.storeRecommends.count, id: \.self) { index in
                        VStack(){
                            HStack {
                                Text(storeModel.recommends[index].title)
                                    .font(.system(size: 24))
                                    .bold()
                                Spacer()
                            }
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    ForEach(storeModel.storeRecommends[index]) { store in
                                        StoreSimpleInfoView(store: store,imgNum: 2)
                                    }
                                }
                            }
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 12))
                            .frame(minHeight: 160)
                        }
                        .padding(10)
                    }
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
