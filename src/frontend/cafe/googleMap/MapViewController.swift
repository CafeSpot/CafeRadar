//
//  MapViewController.swift
//  cafe
//
//  Created by 蔡沅恆 on 2024/2/2.
//

import GoogleMaps
import SwiftUI
import UIKit

class MapViewController: UIViewController {

  let map =  GMSMapView(frame: .zero)
  var isAnimating: Bool = false

  override func loadView() {
    super.loadView()
    self.view = map
  }
}
