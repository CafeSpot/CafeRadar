//
//  GoogleMapView.swift
//  cafe
//
//  Created by 蔡沅恆 on 2024/2/1.
//

import SwiftUI
import GoogleMaps

struct GoogleMapView: UIViewControllerRepresentable {
    @Environment(StoreModel.self) private var storeModel
    var mapViewWillMove: (Bool) -> ()
    
    //listen the event emit from googlemap(marker is tapped)
    final class MapViewCoordinator: NSObject, GMSMapViewDelegate {
        var mapViewControllerBridge: GoogleMapView

        init(_ GoogleMapView: GoogleMapView) {
            self.mapViewControllerBridge = GoogleMapView
        }
        
        func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
            self.mapViewControllerBridge.mapViewWillMove(gesture)
        }
    }

    func makeUIViewController(context: Context) -> MapViewController {
        let uiViewController = MapViewController()
        uiViewController.map.delegate = context.coordinator
        return MapViewController()
    }

    func updateUIViewController(_ uiViewController: MapViewController, context: Context) {
        storeModel.storeBuffer.forEach { $0.marker.map = uiViewController.map }
        //animateToSelectedMarker(viewController: uiViewController)
    }
    
    
    //map view's delegate
    func makeCoordinator() -> MapViewCoordinator {
        return MapViewCoordinator(self)
    }
    
    private func animateToSelectedMarker(viewController: MapViewController) {
        let selectedMarker = storeModel.storeBuffer[0].marker

        let map = viewController.map
        if map.selectedMarker != selectedMarker {
            map.selectedMarker = selectedMarker
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                map.animate(toZoom: kGMSMinZoomLevel)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    map.animate(with: GMSCameraUpdate.setTarget(selectedMarker.position))
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                        map.animate(toZoom: 12)
                    })
                }
            }
        }
    }
}

 
#Preview {
    GoogleMapView(mapViewWillMove: { (isGesture) in
        guard isGesture else { return }
      })
        .environment(StoreModel())
        .environment(MapViewModeModel())
}
