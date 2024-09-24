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
    
    @Environment(StoreModel.self) private var storeModel
    @Environment(UserModel.self) private var userModel
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading){
                //images
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(store.imageLinks, id: \.self) { url in
                            AsyncImageView(url: url, idToken: storeModel.idToken)
                                .scaledToFill()
                                .frame(width: 250, height: 250)
                                .cornerRadius(17)
                                .clipped()
                        }
                        ForEach(0..<(3 - min(store.imageLinks.count, 3)), id: \.self) { _ in
                            Image(systemName: "plus.square")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 250, height: 250)
                                .clipped()
                                .opacity(0.1)
                                .foregroundStyle(.black)
                        }
                        Spacer()
                    }
                }
                .padding(.leading, 14)
                .padding(.trailing , 14)
                
                HStack{
                    Text(store.name)
                        .fontWeight(.bold)
                        .font(.system(size: 27))
                    //.font(.custom("YourCustomFontName-Bold", size: 24))
                    Spacer()
                    VStack{
                        CrowdRateView(crowdRate: store.crowdRate ?? 0.0)
                        
                        Spacer()
                        
                        Button(action: {
                            if userModel.user.favCafeIds.contains(store.cafeId) {
                                userModel.delete_favCafe(cafeId: store.cafeId)
                            } else {
                                userModel.add_favCafe(cafeId: store.cafeId)
                            }
                        }) {
                            // Display the appropriate heart icon
                            if userModel.user.favCafeIds.contains(store.cafeId) {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                            } else {
                                Image(systemName: "star")
                                    .foregroundColor(.gray)
                            }
                        }

                    }
                }
                .padding(.leading, leadingAmount)
                .padding(.trailing, 20)
                .padding(.top, 10)
                .padding(.bottom, 20)
                
                Divider()
                
                VStack(alignment: .leading){
                    Text("店家類別")
                    autoArrayLayoutView{
                        ForEach(store.tags, id: \.self) { tag in
                            typeView(typeName: tag, typeImage: "questionmark.app.dashed")
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
                    Link(store.address ?? "not provide", destination: URL(string: store.addressLink ?? "https://")!)
                        .foregroundColor(.black)
                }
                .padding(.leading, leadingAmount)
                
                Divider()
                
                VStack(alignment: .leading){
                    Text("聯絡資訊")
                    HStack{
                        Image(systemName: "phone.fill")
                        Link(store.phone ?? "not provide", destination: URL(string: "tel:\(store.phone ?? "not provide")")!)
                            .foregroundColor(.black)
                        Spacer()
                        Image(systemName: "f.square")
                        Link(store.ig ?? "not provide", destination: URL(string: store.igLink ?? "https://")!)
                            .foregroundColor(.black)
                        Spacer()
                        Image(systemName: "i.square")
                        Link(store.fb ?? "not provide", destination: URL(string: store.fbLink ?? "https://")!)
                            .foregroundColor(.black)
                    }
                }
                .padding(.trailing, leadingAmount)
                .padding(.leading, leadingAmount)
                
                Divider()
                
                Divider()
                
                HStack{
                    VStack(alignment: .leading){
                        Text(String(format: "%.2f 公尺", store.distance ?? 0.0))
                        Text("營業時間: \(store.openTime ?? "not provided")-\(store.closeTime ?? "not provided")")
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        print("go to map!")
                    }) {
                        Text("前往導航")
                            .padding()
                            .background(CafeColor.basicColor)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                .padding(.top, 20)
                .padding(.trailing, leadingAmount)
                .padding(.leading, leadingAmount)
                
            }
        }
    }
}

#Preview {
    @State var storeInfoModel = StoreInfoModel(stores: [store1] )
    var store: Store = storeInfoModel.stores[0]
    
    return StoreDetailInfo(store: store)
        .environment(StoreModel())
        .environment(UserModel())
}
