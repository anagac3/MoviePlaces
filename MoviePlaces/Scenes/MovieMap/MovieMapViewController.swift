//
//  PlacesViewController.swift
//  MoviePlaces
//
//  Created by Andres Aguilar on 6/23/18.
//  Copyright © 2018 Andres Aguilar. All rights reserved.
//

import UIKit
import MapKit

class MovieMapViewController: UIViewController {

    @IBOutlet weak var map: MKMapView!
    private let initialZoom: Double = 15000
    
    private let interactor: MovieMapInteractor
    
    var movie: Movie? {
        didSet {
            title = movie!.title
            interactor.getLocations(for: movie!)
        }
    }
    
    private var locations: [LocationAnnotation]?

    
    init(interactor: MovieMapInteractor) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        map.delegate = self
        centerOnCoordinate(latitude: MoviePlacesConstants.initialCoordinateLatitude, longitude: MoviePlacesConstants.initialCoordinateLongitude, zoomRadius: initialZoom, animated: false)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if let locations = locations {
            map.removeAnnotations(locations)
            self.locations = nil
        }
    }
    
    private func centerOnCoordinate(latitude: Double, longitude: Double, zoomRadius: Double, animated: Bool) {
        let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(coordinates, zoomRadius, zoomRadius)
        map.setRegion(coordinateRegion, animated: animated)
    }
    
    private func addAnnotations() {
        if let map = map, let locations = locations {
            map.addAnnotations(locations)
            map.showAnnotations(locations, animated: true)
        }
    }
}

extension MovieMapViewController: MovieMapViewControllerDelegate {
    
    func successFetchedLocations(locations: [LocationAnnotation]) {
        if let previousLocations = self.locations {
            map.removeAnnotations(previousLocations)
        }
        self.locations = locations
        //Map may not be initialized, so give it a little time
        if (map == nil) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
               self.addAnnotations()
            }
        }else {
           addAnnotations()
        }
    }
    
    func failedFetchingLocations(error: String) {
        
    }
}

extension MovieMapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "MovieMapAnnotation"
        var view: MKMarkerAnnotationView
        guard let locationAnnotation = annotation as? LocationAnnotation else  { return nil }
        
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
            dequeuedView.annotation = locationAnnotation
            view = dequeuedView
        }else {
            view = MKMarkerAnnotationView(annotation: locationAnnotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }
}
