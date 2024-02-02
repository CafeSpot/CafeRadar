//
//  SearchBarView.swift
//  cafe
//
//  Created by 蔡沅恆 on 2024/2/1.
//

import SwiftUI


struct SearchBarView: View {
    @State private var selectionText: String = ""
    @State private var ifSelectionText: Bool = false
    @Environment(StoreModel.self) private var storeModel
    
    var body: some View {
        VStack {
            TextField("Search", text: $selectionText)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
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
    SearchBarView().environment(StoreModel())
}
