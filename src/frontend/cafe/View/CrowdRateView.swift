//
//  CrowdRateView.swift
//  cafe
//
//  Created by 蔡沅恆 on 2024/2/1.
//

import SwiftUI

struct CrowdRateView: View {
    var crowdRate: Int = 0
    
    var body: some View {
        HStack{
            ForEach(0..<crowdRate, id: \.self) { _ in
                Text("*")
            }
        }
            .frame(width: 33, alignment: .center)
            .font(.system(size: 10))
            .foregroundColor(.black)
            .padding(5)
            .background(Color.yellow)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                .stroke(Color.blue, lineWidth: 2)
            )
            
    }
}

#Preview {
    CrowdRateView(crowdRate: 3)
}
