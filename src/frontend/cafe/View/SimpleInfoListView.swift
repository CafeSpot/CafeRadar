//
//  SimpleInfoListView.swift
//  cafe
//
//  Created by 蔡沅恆 on 2024/2/1.
//

import SwiftUI


struct SimpleInfoListView: View {
    
    @Environment(MapViewModeModel.self) private var mapViewModeModel
    var stores: [Store] = []
    @Binding var selectionText: String
    @Binding var selectionsType: [Bool]
    
    func filtStore(store: Store) -> Bool{
        var ans: Bool
        ans = selectionText=="" ? true : store.cafename.contains(selectionText)
        if ans{
            //type filter design?
        }//if not choosed by searchtext,not show!
        return ans
    }
    
    var body: some View {
        VStack{
            Rectangle()
                .frame(width: 300, height: 7) // Adjust width and height as needed
                .foregroundColor(.gray)
                .cornerRadius(5)
                .padding(.top, 15)
            if mapViewModeModel.mode == .small{
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(stores.filter { filtStore(store: $0) }) { store in
                            StoreSimpleInfoView(store: store,imgNum: 3)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.black, lineWidth: 2)
                                )
                        }
                    }
                }.padding(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12))
            }else if mapViewModeModel.mode == .large{
                ScrollView(showsIndicators: false) {
                    VStack {
                        ForEach(stores.filter { filtStore(store: $0) }) { store in
                            StoreSimpleInfoView(store: store,imgNum: 5)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.black, lineWidth: 2)
                                )
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
    //@State var mode: SimpleInfoListView.Mode = .close
    let stores: [Store] = testStores
    
    return SimpleInfoListView(stores: stores, selectionText: $selectionText, selectionsType: $selectionsType)
        .environment(StoreModel())
        .environment(MapViewModeModel())
}
