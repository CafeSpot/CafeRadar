//
//  SimpleInfoListView.swift
//  cafe
//
//  Created by 蔡沅恆 on 2024/2/1.
//

import SwiftUI

struct SimpleInfoListView: View {
    enum Mode{
        case open
        case close
    }
    
    @Binding var mode: Mode
    var stores: [Store] = []
    
    var body: some View {
        if mode == .close{
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(stores) { store in
                        StoreSimpleInfoView(store: store,imgNum: 3)
                            .padding(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.black, lineWidth: 2)
                            )
                    }
                }
            }
        }else{
            ScrollView(showsIndicators: false) {
                VStack {
                    ForEach(stores) { store in
                        StoreSimpleInfoView(store: store,imgNum: 5)
                            .padding(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.black, lineWidth: 2)
                            )
                    }
                }
            }
            
        }
    }
}

#Preview {
        
    //@State var mode: SimpleInfoListView.Mode = .close
    @State var mode: SimpleInfoListView.Mode = .open
    let stores: [Store] = testStores
    
    return SimpleInfoListView(mode: $mode, stores: stores)
}
