//
//  MapView.swift
//  cafe
//
//  Created by 蔡沅恆 on 2024/2/1.
//

import SwiftUI

struct MapView: View {
    @State private var mode: SimpleInfoListView.Mode = .close
    @Environment(StoreModel.self) private var storeModel
    var body: some View {
        NavigationStack {
            VStack{
                SearchBarView()
                //.foregroundColor(.black)
                    .padding(5)
                    .background(Color.clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.blue, lineWidth: 1)
                    )
                GoogleMapView()
                Spacer()
                VStack{
                    Rectangle()
                        .frame(width: 300, height: 7) // Adjust width and height as needed
                        .foregroundColor(.gray)
                        .cornerRadius(5)
                    SimpleInfoListView(mode: $mode, stores: storeModel.storeBuffer)
                        .gesture(
                            DragGesture()
                                .onEnded({ value in
                                    // Detect vertical drag direction
                                   mode = value.translation.height>0 ? .close : .open
                                })
                        )
                }
            }
        }
    }
}

#Preview {
    MapView().environment(StoreModel())
}
