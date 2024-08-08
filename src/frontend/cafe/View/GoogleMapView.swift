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
    @Environment(UserModel.self) private var userModel
    var markerTappedAction: ((Int) -> Void)?
    private let defaultZoomLevel: Float = 10
    
    class MapViewCoordinator: NSObject, GMSMapViewDelegate {
        var mapView: GoogleMapView

        init(_ googleMapView: GoogleMapView) {
            self.mapView = googleMapView
        }

        
        func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
            //mapView.delegate = self
            print("tap the marker")
            if let index = self.mapView.storeModel.storeBuffer.firstIndex(where: { $0.marker == marker }) {
                self.mapView.markerTappedAction?(index)
            }
            return true
        }
    }


    func makeUIView(context: Context) -> GMSMapView {
        // Create a GMSMapView centered around the city of San Francisco, California
        //let sanFrancisco = CLLocationCoordinate2D(latitude: 37.7576, longitude: -122.4194)
        //gmsMapView.camera = GMSCameraPosition.camera(withTarget: sanFrancisco, zoom: defaultZoomLevel)
        let gmsMapView = GMSMapView(frame: .zero)
        if let position = storeModel.position{
            gmsMapView.camera = GMSCameraPosition.camera(withLatitude: position.coordinate.latitude, longitude: position.coordinate.longitude, zoom: defaultZoomLevel)
        }
        gmsMapView.delegate = context.coordinator
        gmsMapView.isUserInteractionEnabled = true
        return gmsMapView
    }

    func updateUIView(_ uiView: GMSMapView, context: Context) {
        
        if let position = storeModel.position{
            let camera = GMSCameraPosition.camera(withLatitude: position.coordinate.latitude, longitude: position.coordinate.longitude, zoom: defaultZoomLevel)
            uiView.animate(to: camera)
        }
    
        storeModel.storeBuffer.forEach {
            $0.marker.map = uiView
            if $0.crowdRate == 1 {
                $0.marker.icon = UIImage(systemName: "person.circle.fill")
            }else if $0.crowdRate == 2 {
                $0.marker.icon = UIImage(systemName: "person.2.circle.fill")
            }else if $0.crowdRate == 3 {
                $0.marker.icon = UIImage(systemName: "person.3.fill")
            }
            
        }
    }
    
    //map view's delegate
    func makeCoordinator() -> MapViewCoordinator {
        return MapViewCoordinator(self)
    }
}

 
#Preview {
    GoogleMapView()
        .environment(StoreModel())
        .environment(MapViewModeModel())
        .environment(UserModel())
}
