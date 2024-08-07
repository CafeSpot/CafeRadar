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
    
    let elementPadding: CGFloat = 6
    let imageSize: CGFloat = 110
    let strokeWidth: CGFloat = 4
    
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
                            .frame(width: imageSize, height: imageSize)
                            .clipped()
                            .cornerRadius(20)
                        Spacer()
                    }
                    //ForEach(0..<(imgNum - store.images.count)) { _ in
                    ForEach(0..<(imgNum - min(store.images.count, imgNum)), id: \.self) { _ in
                        Image(systemName: "plus.square")
                            .resizable()
                            .cornerRadius(20)
                            .scaledToFit()
                            .frame(width: imageSize, height: imageSize)
                            .clipped()
                            .opacity(0.1)
                            .foregroundStyle(.black)
                    }
                }
                .padding(.leading, elementPadding)
                
                Spacer()
                
                HStack(){
                    Text(store.name)
                        .bold()
                    Spacer()
                }
                .padding(.leading, elementPadding)
                .padding(.bottom, 4)
                
                HStack(alignment: .top){
                    //left
                    VStack(alignment: .leading){
                        
                        HStack(){
                            HStack(spacing: 0){
                                Text(String(store.rate))
                                    .foregroundColor(CafeColor.basicColor)
                                    .font(.system(size: 13))
                                Image(systemName: "star.fill")
                                    .foregroundColor(CafeColor.basicColor)
                                    .font(.system(size: 13))
                            }
                            
                            Text(String(store.distance)+"公尺")
                                .foregroundColor(CafeColor.basicColor)
                                .font(.system(size: 13))
                        }
                        
                        Text("營業時間 "+store.openTime+"-"+store.closeTime)
                            .foregroundColor(CafeColor.basicColor)
                            .font(.system(size: 13))
                        
                    }
                    
                    
                    Spacer()
                    
                    // right
                    VStack{
                        Spacer()
                        CrowdRateView(crowdRate: store.crowdRate)
                    }
                    
                }
                .padding(.leading, elementPadding)
            }
            .frame(width: imgNum==2 ? 230 : 350, height: 170)
            .padding(12)
            .foregroundColor(.black)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(CafeColor.basicColor, lineWidth: strokeWidth)
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

