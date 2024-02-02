//
//  MapView.swift
//  cafe
//
//  Created by 蔡沅恆 on 2024/2/1.
//

import SwiftUI

struct MapView: View {
    @Environment(StoreModel.self) private var storeModel
    @Environment(MapViewModeModel.self) private var mapViewModeModel
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
                ZStack(alignment: .top){
                    
                    GoogleMapView()
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.black, lineWidth: 2)
                        )
                    
                    VStack{
                        Spacer()

                        SimpleInfoListView(stores: storeModel.storeBuffer)
                            .contentShape(Rectangle())
                            .background(Color.white)
                            .gesture(
                                DragGesture()
                                    .onEnded({ value in
                                        //value.translation.height
                                        mapViewModeModel.dragGestureModel(varyAmount: value.translation.height)
                                    })
                            )
                    }
                }
            }
        }
    }
}

#Preview {
    MapView()
        .environment(StoreModel())
        .environment(MapViewModeModel())
}
