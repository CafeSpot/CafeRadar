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
                            .frame(width: 60, height: 60)
                            .clipped()
                    }
                }
                
                HStack{
                    VStack(alignment: .leading){
                        Text("name: "+store.cafeId)
                        Text("distance: "+String(store.distance)+"m")
                        Text("time: "+store.openTime)
                        Text("   "+store.openTime)
                        Text("   "+store.closeTime)
                        
                    }
                    Spacer()
                    CrowdRateView(crowdRate: store.crowdRate)
                    
                }
                .font(.system(size: 13))
                HStack {
                    Text("hashtag: ")
                        .font(.system(size: 10))
                    ForEach(store.tags.prefix(4)) { item in
                        Text(item.tag)
                            .font(.system(size: 10))
                            .foregroundColor(.black)
                            .padding(5)
                            .background(Color.gray)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.blue, lineWidth: 2)
                            )
                    }
                }
                
            }
                .background(Color.white)
        }
    }
}

#Preview {
    @State var storeInfoModel = StoreInfoModel(stores: [store1] )
    var store: Store{
        return storeInfoModel.stores.first(where: { $0.placeId == "1223" }) ?? Store(placeId: "null")
    }
    
    return StoreSimpleInfoView(store: store, imgNum: 4)
}

