//
//  GoogleMapView.swift
//  cafe
//
//  Created by 蔡沅恆 on 2024/2/1.
//

import SwiftUI
import GoogleMaps

struct GoogleMapView: UIViewControllerRepresentable {

  func makeUIViewController(context: Context) -> MapViewController {
    return MapViewController()
  }

  func updateUIViewController(_ uiViewController: MapViewController, context: Context) {
  }
}

 
#Preview {
    GoogleMapView()
}
