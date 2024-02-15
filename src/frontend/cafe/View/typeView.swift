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
    var black: Bool = true
    
    var body: some View {
        HStack{
            Image(systemName: typeImage)
                .foregroundColor(black ? .black : .gray)
            Text(type)
                .font(.system(size: 15))
                .foregroundColor(black ? .black : .gray)
                .lineLimit(nil)
        }
        .padding(2)
        .overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(black ? .black : .gray, lineWidth: 1)
        )
    }
}

#Preview {
    typeView(type: "aaa", typeImage: "questionmark.app.dashed", black: true)
}
