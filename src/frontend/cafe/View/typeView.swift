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
    
    
    var body: some View {
        HStack{
            Image(systemName: typeImage)
                .foregroundColor(.black)
            Text(type)
                .font(.system(size: 15))
                .foregroundColor(.black)
                .lineLimit(nil)
        }
        .padding(2)
        .overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color.black, lineWidth: 1)
        )
    }
}

#Preview {
    typeView(type: "aaa", typeImage: "questionmark.app.dashed")
}
