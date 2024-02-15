//
//  SimpleInfoListView.swift
//  cafe
//
//  Created by 蔡沅恆 on 2024/2/1.
//

import SwiftUI
import CoreLocation

struct SimpleInfoListView: View {
    @Environment(StoreModel.self) private var storeModel
    @Environment(MapViewModeModel.self) private var mapViewModeModel
    
    var body: some View {
        VStack{
            if mapViewModeModel.mode == .small{
                Rectangle()
                    .frame(width: 100, height: 2) // Adjust width and height as needed
                    .foregroundColor(.black)
                    .cornerRadius(5)
                    .padding(.top, 9)
                    .padding(.bottom, 3)
            }else if mapViewModeModel.mode == .large{
                Button(action: {
                    mapViewModeModel.mode = .close
                }, label: {
                    HStack{
                        Image(systemName: "chevron.down")
                            .foregroundColor(.black)
                            .padding(.bottom, 5)
                            .padding(.leading, 12)
                            .padding(.top, 14)
                        Spacer()
                    }
                })
            }else{
                VStack{
                    Rectangle()
                        .frame(width: 100, height: 2) // Adjust width and height as needed
                        .foregroundColor(.black)
                        .cornerRadius(5)
                        .padding(.top, 9)
                        .padding(.bottom, 3)
                    Text("搜尋到\(storeModel.storeCollection.count)家咖啡廳")
                        .font(.system(size: 20))
                        .bold()
                        .padding(4)
                }
            }
            
            if mapViewModeModel.mode == .small{
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(storeModel.storeCollection) { store in
                            StoreSimpleInfoView(store: store,imgNum: 2)
                        }
                    }
                }
                .padding(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12))
                .frame(minHeight: 160)
            }else if mapViewModeModel.mode == .large{
                ScrollView(showsIndicators: false) {
                    VStack {
                        ForEach(storeModel.storeCollection) { store in
                            StoreSimpleInfoView(store: store,imgNum: 3)
                        }
                    }
                }.padding(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12))
            }
            else{
                //no
            }
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    @State var selectionText: String = ""
    @State var selectionsType: [Bool] = [false, false, false, false, false]
    @State var selectedDistance: Double = 100000
    //@State var mode: SimpleInfoListView.Mode = .close
    let stores: [Store] = testStores
    @State var mapViewModeModel = MapViewModeModel()
    //mapViewModeModel.large()
    mapViewModeModel.small()
    //mapViewModeModel.close()
    
    return SimpleInfoListView()
        .environment(StoreModel())
        .environment(mapViewModeModel)
}
