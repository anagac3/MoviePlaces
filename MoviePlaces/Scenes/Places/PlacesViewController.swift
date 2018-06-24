//
//  PlacesViewController.swift
//  MoviePlaces
//
//  Created by Andres Aguilar on 6/23/18.
//  Copyright © 2018 Andres Aguilar. All rights reserved.
//

import UIKit
import MapKit

class PlacesViewController: UIViewController {

    @IBOutlet weak var map: MKMapView!
    private let initialZoom: Double = 1000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        centerOnCoordinate(latitude: MoviePlacesConstants.initialCoordinateLatitude, longitude: MoviePlacesConstants.initialCoordinateLongitude, zoomRadius: initialZoom, animated: false)
    }
    
    private func centerOnCoordinate(latitude: Double, longitude: Double, zoomRadius: Double, animated: Bool) {
        let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(coordinates, zoomRadius, zoomRadius)
        map.setRegion(coordinateRegion, animated: animated)
    }

}
