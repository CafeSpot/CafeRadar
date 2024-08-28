//
//  GoogleMapView.swift
//  cafe
//
//  Created by 蔡沅恆 on 2024/2/1.
//

import SwiftUI
import GoogleMaps

struct MarkerData{
    var lon: Double
    var lat: Double
    var rate: Int
    var index: Int
}

struct GoogleMapView: UIViewRepresentable {
    @Environment(StoreModel.self) private var storeModel
    @Environment(UserModel.self) private var userModel
    var markerTappedAction: ((Int) -> Void)?
    private let defaultZoomLevel: Float = 10
    var markerDatas: [MarkerData]{
        self.storeModel.storeMap.enumerated().map { (index, store) in
            MarkerData(
                lon: store.lon,
                lat: store.lat,
                rate: store.crowdRate,
                index: index
            )
        }
    }
    
    class MapViewCoordinator: NSObject, GMSMapViewDelegate {
        var mapView: GoogleMapView

        init(_ googleMapView: GoogleMapView) {
            self.mapView = googleMapView
        }

        
        func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
            //mapView.delegate = self
            print("[GoogleMapView]: tap the marker")
            if let data = marker.userData as? Int {
                self.mapView.markerTappedAction?(data) // Pass the tapped marker's data
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
        uiView.clear()
        
        if let position = storeModel.position{
            let camera = GMSCameraPosition.camera(withLatitude: position.coordinate.latitude, longitude: position.coordinate.longitude, zoom: defaultZoomLevel)
            uiView.animate(to: camera)
        }
        
        for markerData in markerDatas{
            let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: markerData.lat, longitude: markerData.lon))
            marker.map = uiView
            marker.userData = markerData.index
            if markerData.rate <= 1 {
                marker.icon = UIImage(systemName: "person.circle.fill")
            }else if markerData.rate <= 2 {
                marker.icon = UIImage(systemName: "person.2.circle.fill")
            }else if markerData.rate <= 3 {
                marker.icon = UIImage(systemName: "person.3.fill")
            }
        }
    }
    
    //map view's delegate
    func makeCoordinator() -> MapViewCoordinator {
        return MapViewCoordinator(self)
    }
}


/*
#Preview {
    GoogleMapView()
        .environment(MapViewModeModel())
        .environment(UserModel())
}
*/
