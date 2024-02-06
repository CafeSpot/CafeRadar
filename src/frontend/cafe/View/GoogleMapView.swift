//
//  GoogleMapView.swift
//  cafe
//
//  Created by 蔡沅恆 on 2024/2/1.
//

import SwiftUI
import GoogleMaps

struct GoogleMapView: UIViewRepresentable {
    @Environment(StoreModel.self) private var storeModel
    var markerTappedAction: ((Int) -> Void)?
    private let gmsMapView = GMSMapView(frame: .zero)
    private let defaultZoomLevel: Float = 10


    func makeUIView(context: Context) -> GMSMapView {
        // Create a GMSMapView centered around the city of San Francisco, California
        //let sanFrancisco = CLLocationCoordinate2D(latitude: 37.7576, longitude: -122.4194)
        //gmsMapView.camera = GMSCameraPosition.camera(withTarget: sanFrancisco, zoom: defaultZoomLevel)
        gmsMapView.delegate = context.coordinator
        gmsMapView.isUserInteractionEnabled = true
        return gmsMapView
    }

    func updateUIView(_ uiView: GMSMapView, context: Context) {
    
         storeModel.storeBuffer.forEach { $0.marker.map = uiView }
    }
    
    //map view's delegate
    func makeCoordinator() -> MapViewCoordinator {
        return MapViewCoordinator(self)
    }
    
    final class MapViewCoordinator: NSObject, GMSMapViewDelegate {
        var mapView: GoogleMapView

        init(_ googleMapView: GoogleMapView) {
            self.mapView = googleMapView
        }

        
        func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
            mapView.delegate = self
            print("tap the marker")
            if let index = self.mapView.storeModel.storeBuffer.firstIndex(where: { $0.marker == marker }) {
                self.mapView.markerTappedAction?(index)
            }
            return true
        }
    }
}

 
#Preview {
    GoogleMapView()
        .environment(StoreModel())
        .environment(MapViewModeModel())
}
