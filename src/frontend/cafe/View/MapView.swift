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
    @State private var selectionText: String = ""
    @State private var selectionsType: [Bool] = [false, false, false, false, false]
    var body: some View {
        NavigationStack {
            VStack{
                SearchBarView(selectionText: $selectionText, selectionsType: $selectionsType)
                //.foregroundColor(.black)
                    .padding(5)
                    .background(Color.clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.blue, lineWidth: 1)
                    )
                ZStack(alignment: .top){
                    
                    GoogleMapView(mapViewWillMove: { (isGesture) in
                        guard isGesture else { return }
                      })
                    
                    VStack{
                        Spacer()

                        SimpleInfoListView(stores: storeModel.storeBuffer, selectionText: $selectionText, selectionsType: $selectionsType)
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
                        .padding(EdgeInsets(top: 0, leading: 7, bottom: 0, trailing: 7))
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
