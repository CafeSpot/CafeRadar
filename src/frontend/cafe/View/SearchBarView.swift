//
//  SearchBarView.swift
//  cafe
//
//  Created by 蔡沅恆 on 2024/2/1.
//

import SwiftUI


struct SearchBarView: View {
    @Environment(StoreModel.self) private var storeModel
    @Environment(MapViewModeModel.self) private var mapViewModeModel
    
    var ifText = true
    var ifType = true
    var ifDistance = true
    
    var body: some View {
        @Bindable var storeModel = storeModel
        VStack(alignment: .leading) {

            // [component] searchbar
            if(ifText){
                HStack{
                    Image(systemName: "magnifyingglass")
                        .padding(.leading, 6)
                        .padding(5)
                        .foregroundColor(CafeColor.basicColor)
                    
                    TextField("搜尋咖啡廳", text: $storeModel.selectionText)
                        .padding(6)
                        .autocapitalization(.none)
                        .textFieldStyle(PlainTextFieldStyle())
                        .onChange(of: storeModel.selectionText) { value in
                            mapViewModeModel.ifSearchText(searchText: value)
                        }
                    
                    Button(action: {
                        storeModel.selectionText = ""
                        storeModel.selectedDistance = 10000
                        for index in storeModel.selectionsType.indices{
                            storeModel.selectionsType[index].selected = true
                            storeModel.selectionsTypeCount = storeModel.selectionsType.count
                        }
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(CafeColor.basicColor)
                    }
                    .padding(.trailing,6)
                    .padding(5)
                }
                .background(Color(UIColor.lightGray))
                .cornerRadius(14)
                .padding(.trailing,20)
            }
            
            // [component] choose type
            if(ifType){
                HStack {
                    Image(systemName: "slider.horizontal.3")
                        .padding(5)
                        .foregroundColor(CafeColor.basicColor)
                    ScrollView(.horizontal,showsIndicators: false){
                        HStack{
                            ForEach(storeModel.selectionsType.indices, id: \.self) { index in
                                Button(action: {
                                    if storeModel.selectionsType[index].selected{
                                        storeModel.selectionsTypeCount-=1
                                        storeModel.selectionsType[index].selected = false
                                    }else{
                                        storeModel.selectionsTypeCount+=1
                                        storeModel.selectionsType[index].selected = true
                                    }
                                }) {
                                    typeView(type: storeModel.selectionsType[index].tag,
                                             typeImage: "questionmark.app.dashed",
                                             ifChoose: storeModel.selectionsType[index].selected)
                                }
                            }
                        }
                    }
                    Spacer()
                }
                .padding(.top,5)
                .frame(minWidth: nil, maxWidth: .infinity)
            }
            
            // [component] choose distance
            if(ifDistance){
                HStack{
                    Slider(value: $storeModel.selectedDistance, in: 0...10000)
                        .accentColor(CafeColor.basicColor)
                    Text(String(format: "%.2f", storeModel.selectedDistance/1000)+"km")
                        .foregroundColor(CafeColor.basicColor)
                }
                .padding(.leading, 30)
                .padding(.trailing, 30)
            }
        }
    }
}

#Preview {
    @State var selectionText: String = ""
    @State var selectionsType: [Bool] = [false, false, false, false, false]
    @State var selectedDistance: Double = 100000
    return SearchBarView()
        .environment(StoreModel())
        .environment(MapViewModeModel())
}
