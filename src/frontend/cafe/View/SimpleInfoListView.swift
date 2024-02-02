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
                        ForEach(stores) { store in
                            StoreSimpleInfoView(store: store,imgNum: 3)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.black, lineWidth: 2)
                                )
                        }
                    }
                }
            }else if mapViewModeModel.mode == .large{
                ScrollView(showsIndicators: false) {
                    VStack {
                        ForEach(stores) { store in
                            StoreSimpleInfoView(store: store,imgNum: 5)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.black, lineWidth: 2)
                                )
                        }
                    }
                }
            }
            else{
                //no
            }
        }
            .frame(maxWidth: .infinity)
    }
}

#Preview {
        
    //@State var mode: SimpleInfoListView.Mode = .close
    let stores: [Store] = testStores
    
    return SimpleInfoListView(stores: stores)
}
