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
    @Binding var selectionText: String
    @Binding var selectionsType: [Bool]
    
    var body: some View {
        VStack(alignment: .leading) {
            //HStack{
                HStack{
                    Image(systemName: "magnifyingglass")
                        .padding(.leading, 6)
                        .padding(5)
                    
                    TextField("請輸入內容", text: $selectionText)
                        .padding(6)
                        .autocapitalization(.none)
                        .textFieldStyle(PlainTextFieldStyle())
                        .onChange(of: selectionText) { value in
                            mapViewModeModel.ifSearchText(searchText: value)
                        }
                    
                    Button(action: {
                        selectionText = ""
                    }) {
                        Image(systemName: "x.circle")
                            .foregroundColor(.black)
                    }
                    .padding(.trailing,6)
                    .padding(5)
                }
            
                .background(Color(UIColor.lightGray))
                .cornerRadius(14)
                .padding(.trailing,20)
            
                
                /*
                //預想是只要輸入搜尋就能夠自動找尋附近資料，但目前可能會遇到問題是這需要打很多次google api，先以search來減少？
                Button(action: {
                    if selectionText != ""{
                        storeModel.searchText(text: selectionText)
                    }
                }) {
                    Text("search")
                        .font(.system(size: 10))
                        .padding(5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                               .stroke(Color.blue, lineWidth: 2)
                        )
                }
                 */
                
            //}
            
            HStack {
                //slider.horizontal.3
                Image(systemName: "slider.horizontal.3")
                    .padding(5)
                ScrollView(.horizontal,showsIndicators: false){
                    HStack{
                        ForEach(storeModel.types, id: \.self) { type in
                            Button(action: {
                                print("Image button tapped!")
                            }) {
                                typeView(type: type, typeImage: "questionmark.app.dashed")
                            }
                        }
                    }
                }
                Spacer()
            }
            .padding(.top,5)
            .frame(minWidth: nil, maxWidth: .infinity)
            
        }
    }
}

#Preview {
    @State var selectionText: String = ""
    @State var selectionsType: [Bool] = [false, false, false, false, false]
    return SearchBarView(selectionText: $selectionText, selectionsType: $selectionsType)
        .environment(StoreModel())
        .environment(MapViewModeModel())
}
