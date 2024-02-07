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
                    Text("搜尋到12家咖啡廳")
                        .font(.system(size: 20))
                        .bold()
                        .padding(4)
                }
            }
            
            if mapViewModeModel.mode == .small{
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(stores.filter { filtStore(store: $0) }) { store in
                            StoreSimpleInfoView(store: store,imgNum: 2)
                        }
                    }
                }.padding(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12))
            }else if mapViewModeModel.mode == .large{
                ScrollView(showsIndicators: false) {
                    VStack {
                        ForEach(stores.filter { filtStore(store: $0) }) { store in
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
    //@State var mode: SimpleInfoListView.Mode = .close
    let stores: [Store] = testStores
    @State var mapViewModeModel = MapViewModeModel()
    //mapViewModeModel.large()
    //mapViewModeModel.small()
    mapViewModeModel.close()
    
    return SimpleInfoListView(stores: stores, selectionText: $selectionText, selectionsType: $selectionsType)
        .environment(StoreModel())
        .environment(mapViewModeModel)
}
