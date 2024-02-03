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
        VStack {
            HStack{
                TextField("Search", text: $selectionText)
                    .autocapitalization(.none)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onChange(of: selectionText) { value in
                        mapViewModeModel.ifSearchText(searchText: value)
                    }
                
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
                
            }
            
            HStack {
                ForEach(storeModel.types, id: \.self) { type in
                        Button(action: {
                            // Action to perform when the button is tapped
                            print("Image button tapped!")
                        }) {
                            Text(type)
                                .font(.system(size: 10))
                                .padding(5)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                       .stroke(Color.blue, lineWidth: 2)
                                )
                        }
                    }
            }
            
        }
        .padding()
    }
}

#Preview {
    @State var selectionText: String = "1"
    @State var selectionsType: [Bool] = [false, false, false, false, false]
    return SearchBarView(selectionText: $selectionText, selectionsType: $selectionsType)
        .environment(StoreModel())
        .environment(MapViewModeModel())
}
