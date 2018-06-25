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
    private let movie: Movie
    private var locations: [LocationAnnotation]?
    
    init(selectedMovie: Movie, interactor: MovieMapInteractor) {
        self.interactor = interactor
        self.movie = selectedMovie
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = movie.title
        map.delegate = self
        centerOnCoordinate(latitude: MoviePlacesConstants.initialCoordinateLatitude, longitude: MoviePlacesConstants.initialCoordinateLongitude, zoomRadius: initialZoom, animated: false)
        interactor.getLocations(for: movie)
    }
    
    private func centerOnCoordinate(latitude: Double, longitude: Double, zoomRadius: Double, animated: Bool) {
        let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(coordinates, zoomRadius, zoomRadius)
        map.setRegion(coordinateRegion, animated: animated)
    }
}

extension MovieMapViewController: MovieMapViewControllerDelegate {
    
    func successFetchedLocations(locations: [LocationAnnotation]) {
        self.locations = locations
        map.addAnnotations(locations)
        map.showAnnotations(locations, animated: true)
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