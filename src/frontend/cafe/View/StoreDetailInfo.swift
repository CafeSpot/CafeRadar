//
//  StoreDetailInfo.swift
//  cafe
//
//  Created by 蔡沅恆 on 2024/2/1.
//

import SwiftUI


struct StoreDetailInfo: View {
    var store: Store
    
    var body: some View {
        VStack{
            //images
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(store.images) { image in
                        image.image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 170, height: 170)
                            .border(Color.pink)
                            .clipped()
                    }
                }
            }
            
            HStack{
                Text(store.cafename)
                Spacer()
                CrowdRateView(crowdRate: store.crowdRate)
            }
            
            VStack{
                Text("店家類別")
                HStack{   //modify to the grid!!!
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
            
            VStack{
                Text("菜單")
            }
            
            VStack{
                Text("店家地址")
                Text(store.address)
            }
            
            VStack{
                Text("聯絡資訊")
                HStack{
                    Text(store.phone)
                    Text(store.ig)
                    Text(store.fb)
                }
            }
            
            HStack{
                VStack{
                    Text(String(store.distance)+"公尺")
                    Text("營業時間 "+String(store.openTime)+"~"+String(store.closeTime))
                }
                
                Button(action: {
                    print("go to map!")
                }) {
                    Text("前往導航")
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.gray)
                        .cornerRadius(8)
                }
            }
            
        }
    }
}

#Preview {
    @State var storeInfoModel = StoreInfoModel(stores: [store1] )
    var store: Store{
        return storeInfoModel.stores.first(where: { $0.placeId == "1223" }) ?? Store(placeId: "null")
    }
    
    return StoreDetailInfo(store: store)
}
