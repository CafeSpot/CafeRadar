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
                Image(systemName: "person.fill")
            }
        }
            .frame(width: 38, alignment: .center)
            .font(.system(size: 10))
            .foregroundColor(.black)
            .padding(5)
            .background(Color(UIColor.lightGray))
            .cornerRadius(3)
            
    }
}

#Preview {
    CrowdRateView(crowdRate: 3)
}
