//
//  typeView.swift
//  cafe
//
//  Created by 蔡沅恆 on 2024/2/6.
//

import SwiftUI

struct typeView: View {
    var type: String
    var typeImage: String
    var ifChoose: Bool = true
    
    var body: some View {
        HStack{
            Image(systemName: typeImage)
                .foregroundColor(ifChoose ? .white : CafeColor.basicColor)
            Text(type)
                .font(.system(size: 15))
                .foregroundColor(ifChoose ? .white : CafeColor.basicColor)
                .lineLimit(nil)
        }
        .padding(2)
        .background(
            RoundedRectangle(cornerRadius: 5)
                .fill(ifChoose ? CafeColor.basicColor : Color.clear)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(ifChoose ? Color.clear : CafeColor.basicColor, lineWidth: 1)
        )
    }
}

#Preview {
    VStack(){
        typeView(type: "aaa", typeImage: "questionmark.app.dashed", ifChoose: true)
        typeView(type: "aaa", typeImage: "questionmark.app.dashed", ifChoose: false)
    }
}
