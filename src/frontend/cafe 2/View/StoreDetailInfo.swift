//
//  StoreDetailInfo.swift
//  cafe
//
//  Created by 蔡沅恆 on 2024/2/1.
//

import SwiftUI


struct StoreDetailInfo: View {
    var store: Store
    var leadingAmount: CGFloat = 20
    
    var body: some View {
        VStack(alignment: .leading){
            //images
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(store.images) { image in
                        image.image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 250, height: 250)
                            .cornerRadius(17)
                            .clipped()
                    }
                }
            }
            .padding(.leading, 14)
            .padding(.trailing , 14)
            
            HStack{
                Text(store.cafename)
                    .fontWeight(.bold)
                    .font(.system(size: 27))
                //.font(.custom("YourCustomFontName-Bold", size: 24))
                Spacer()
                CrowdRateView(crowdRate: store.crowdRate)
            }
            .padding(.leading, leadingAmount)
            .padding(.trailing, 20)
            .padding(.top, 10)
            .padding(.bottom, 20)
            
            Divider()
            
            VStack(alignment: .leading){
                Text("店家類別")
                LazyVGrid(columns: Array(repeating: GridItem(), count: 5)) {
                    ForEach(store.tags) { item in
                        typeView(type: item.tag, typeImage: "questionmark.app.dashed")
                    }
                }
            }
            .padding(.trailing, leadingAmount)
            .padding(.leading, leadingAmount)
            
            Divider()
            
            VStack{
                Text("菜單")
            }
            .padding(.leading, leadingAmount)
            
            Divider()
            
            VStack(alignment: .leading){
                Text("店家地址")
                Link(store.address, destination: URL(string: store.addressLink)!)
                    .foregroundColor(.black)
            }
            .padding(.leading, leadingAmount)
            
            Divider()
            
            VStack(alignment: .leading){
                Text("聯絡資訊")
                HStack{
                    Image(systemName: "phone.fill")
                    Link(store.phone, destination: URL(string: "tel:\(store.phone)")!)
                        .foregroundColor(.black)
                    Spacer()
                    Image(systemName: "f.square")
                    Link(store.ig, destination: URL(string: store.igLink)!)
                        .foregroundColor(.black)
                    Spacer()
                    Image(systemName: "i.square")
                    Link(store.fb, destination: URL(string: store.fbLink)!)
                        .foregroundColor(.black)
                }
            }
            .padding(.trailing, leadingAmount)
            .padding(.leading, leadingAmount)
            
            Divider()
            
            Divider()
            
            HStack{
                VStack(alignment: .leading){
                    Text(String(store.distance)+"公尺")
                    Text("營業時間 "+String(store.openTime)+"~"+String(store.closeTime))
                }
                
                Spacer()
                
                Button(action: {
                    print("go to map!")
                }) {
                    Text("前往導航")
                        .padding()
                        .foregroundColor(.black)
                        .background(Color(UIColor.lightGray))
                        .cornerRadius(8)
                }
            }
            .padding(.top, 20)
            .padding(.trailing, leadingAmount)
            .padding(.leading, leadingAmount)
            
        }
    }
}

#Preview {
    @State var storeInfoModel = StoreInfoModel(stores: [store1] )
    var store: Store = storeInfoModel.stores[0]
    
    return StoreDetailInfo(store: store)
}
