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
    @Environment(UserModel.self) private var userModel
    @State private var selectionText: String = ""
    @State private var selectionsType: [Bool] = [false, false, false, false, false]
    @State private var selectedMarkerIndex: Int?
    
    
    var body: some View {
        
        NavigationStack {
            VStack{
                SearchBarView(selectionText: $selectionText, selectionsType: $selectionsType)
                //.foregroundColor(.black)
                    .padding(.top,7)
                    .padding(.bottom,10)
                    .padding(.leading,16)
                    .background(Color.clear)
                
                ZStack(alignment: .top){
                    
                    //GoogleMapView()
                    VStack {
                        NavigationLink(
                            destination: selectedMarkerIndex.map { StoreDetailInfo(store: self.storeModel.storeBuffer[$0]) },
                            isActive: Binding(
                                get: { self.selectedMarkerIndex != nil },
                                set: { _ in self.selectedMarkerIndex = nil }
                            ),
                            label: { EmptyView() }
                        )
                        GoogleMapView() { index in
                            // This closure will be called when a marker is tapped
                            self.selectedMarkerIndex = index
                        }
                    }
                    
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
                        //.padding(EdgeInsets(top: 0, leading: 7, bottom: 0, trailing: 7))
                }
            }
        }
    }
}

#Preview {
    MapView()
        .environment(StoreModel())
        .environment(MapViewModeModel())
        .environment(UserModel())
}
