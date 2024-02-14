//
//  StoreSimpleInfoView.swift
//  cafe
//
//  Created by 蔡沅恆 on 2024/2/1.
//

import SwiftUI


@Observable
class StoreInfoModel{
    var stores: [Store]
    
    init(stores: [Store]) {
        self.stores = stores
    }
}


struct StoreSimpleInfoView: View {

    var store: Store
    var imgNum: Int
    
    var body: some View {
        NavigationLink {
            StoreDetailInfo(store: store)
        } label: {
            VStack{
                HStack {
                    ForEach(store.images.prefix(imgNum)) { image in
                        image.image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 110, height: 110)
                            .clipped()
                            .cornerRadius(10)
                        Spacer()
                    }
                    //ForEach(0..<(imgNum - store.images.count)) { _ in
                    ForEach(0..<(imgNum - min(store.images.count, imgNum)), id: \.self) { _ in
                        Image(systemName: "plus.square")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 110, height: 110)
                            .clipped()
                            .opacity(0.1)
                            .foregroundStyle(.black)
                    }
            
                    Spacer()
                }
                .padding(.leading, 4)
                
                Spacer()
                
                HStack(alignment: .top){
                    VStack(alignment: .leading){
                        Text(store.name)
                            .bold()
                        Text(String(store.distance)+"公尺")
                        Text(store.openTime+"-"+store.closeTime)
                        
                    }
                    .padding(.leading, 8)
                    Spacer()
                    VStack{
                        CrowdRateView(crowdRate: store.crowdRate)
                    }
                    
                }
                .font(.system(size: 13))
                
            }
            .frame(width: imgNum==2 ? 240 : 350, height: 160)
            .padding(10)
            .foregroundColor(.black)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.black, lineWidth: 1)
            )
            .background(Color.white)
        }
    }
}

#Preview {
    @State var storeInfoModel = StoreInfoModel(stores: [store1] )
    //@State var storeInfoModel = StoreInfoModel(stores: [] )
    var store: Store = storeInfoModel.stores[0]
    
    return StoreSimpleInfoView(store: store, imgNum: 3)
}

